/**
 * In-memory OTP store for development when Redis is not available.
 * Implements the same interface we need from Redis (setex, get, del, exists).
 */
export class MemoryOtpStore {
  private readonly store = new Map<
    string,
    { value: string; expiresAt: number }
  >();
  private readonly expiryMs: number;

  constructor(expirySeconds: number) {
    this.expiryMs = expirySeconds * 1000;
  }

  async setex(key: string, _ttl: number, value: string): Promise<void> {
    this.store.set(key, {
      value,
      expiresAt: Date.now() + this.expiryMs,
    });
  }

  async get(key: string): Promise<string | null> {
    const entry = this.store.get(key);
    if (!entry) return null;
    if (Date.now() > entry.expiresAt) {
      this.store.delete(key);
      return null;
    }
    return entry.value;
  }

  async del(key: string): Promise<void> {
    this.store.delete(key);
  }

  async exists(key: string): Promise<number> {
    const v = await this.get(key);
    return v != null ? 1 : 0;
  }
}
