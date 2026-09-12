const { test } = require('node:test');
const assert = require('node:assert/strict');
const { JwtService } = require('@nestjs/jwt');
const { DevAuthController } = require('../dist/modules/auth/controller/dev-auth.controller');
const { requireDevRequest, validateDevSession } = require('../dist/modules/auth/dev-auth.policy');
const { SuperAdminJwtGuard } = require('../dist/modules/auth/guards/jwt-superadmin.guard');

test('development login restrictions, isolated identities, cookies, and session invalidation', async () => {
  const oldEnv = process.env.NODE_ENV;
  const oldFlag = process.env.DEV_AUTH_ENABLED;
  const local = { socket: { remoteAddress: '127.0.0.1' }, headers: {} };
  try {
    for (const environment of ['production', 'test', undefined]) {
      if (environment) process.env.NODE_ENV = environment;
      else delete process.env.NODE_ENV;
      process.env.DEV_AUTH_ENABLED = 'true';
      assert.throws(() => requireDevRequest(local));
      assert.throws(() => validateDevSession({ devAuth: true }));
    }
    process.env.NODE_ENV = 'development';
    delete process.env.DEV_AUTH_ENABLED;
    assert.throws(() => requireDevRequest(local));
    process.env.DEV_AUTH_ENABLED = 'true';
    assert.doesNotThrow(() => requireDevRequest(local));
    assert.throws(() => requireDevRequest({ ...local, socket: { remoteAddress: '192.168.1.20' } }));
    assert.throws(() => requireDevRequest({ ...local, headers: { 'x-forwarded-for': '127.0.0.1' } }));

    const records = new Map();
    const model = name => ({ upsert: async ({ where, create, update }) => {
      assert.deepEqual(update, {}); // Never change an existing identity during login.
      const key = name + JSON.stringify(where);
      if (!records.has(key)) records.set(key, { id: key, ...create });
      return records.get(key);
    } });
    const db = Object.fromEntries(['admin', 'user', 'deliveryPartner', 'userWallet', 'driverWallet']
      .map(name => [name, model(name)]));
    const jwt = new JwtService({ secret: 'test-only-signing-secret' });
    const controller = new DevAuthController(db, jwt);
    const cookies = [];
    const response = { setHeader() {}, cookie: (...args) => cookies.push(args) };
    for (const app of ['super-admin', 'user', 'partner']) {
      const result = await controller.login(local, { app }, response);
      assert.equal(result.success, true);
      const token = app === 'super-admin' ? cookies.at(-1)[1] : result.access_token;
      const payload = jwt.verify(token);
      assert.equal(payload.devAuth, true);
      assert.equal(payload.exp - payload.iat, 7200);
      if (app === 'super-admin') assert.equal(payload.role, 'SUPERADMIN');
      else {
        assert.equal(payload.type, app);
        assert.match(payload.mobile, /^dev-/);
      }
      await controller.login(local, { app }, response);
    }
    assert.equal(records.size, 5);
    assert.equal(cookies[0][0], 'token');
    assert.equal(cookies[0][2].httpOnly, true);

    const guard = new SuperAdminJwtGuard(jwt);
    const context = token => ({ switchToHttp: () => ({
      getRequest: () => ({ headers: { authorization: `Bearer ${token}` } }),
      getResponse: () => response,
    }) });
    const token = cookies[0][1];
    assert.equal(await guard.canActivate(context(token)), true);
    await assert.rejects(() => guard.canActivate(context(jwt.sign({ role: 'USER' }))));
    process.env.DEV_AUTH_ENABLED = 'false';
    await assert.rejects(() => controller.login(local, { app: 'user' }, response));
    await assert.rejects(() => guard.canActivate(context(token)));
    assert.throws(() => validateDevSession({ devAuth: true }));
    assert.doesNotThrow(() => validateDevSession({}));
  } finally {
    if (oldEnv === undefined) delete process.env.NODE_ENV; else process.env.NODE_ENV = oldEnv;
    if (oldFlag === undefined) delete process.env.DEV_AUTH_ENABLED; else process.env.DEV_AUTH_ENABLED = oldFlag;
  }
});
