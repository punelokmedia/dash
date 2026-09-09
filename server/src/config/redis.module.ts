import { Global, Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';
import { MemoryOtpStore } from './memory-otp-store';

export const REDIS_CLIENT = 'REDIS_CLIENT';

/** Redis or in-memory store (same interface: setex, get, del, exists) */
export type OtpStore = Redis | MemoryOtpStore;

@Global()
@Module({
  providers: [
    {
      provide: REDIS_CLIENT,
      useFactory: async (config: ConfigService): Promise<OtpStore> => {
        const expirySeconds = config.get<number>('redis.otpExpirySeconds', 300);
        const redis = new Redis({
          host: config.get<string>('redis.host'),
          port: config.get<number>('redis.port'),
          password: config.get<string>('redis.password'),
          lazyConnect: true,
          maxRetriesPerRequest: 1,
        });
        try {
          await Promise.race([
            new Promise<Redis>((resolve) =>
              redis.once('ready', () => resolve(redis)),
            ),
            new Promise<never>((_, reject) =>
              redis.once('error', (err: Error) => reject(err)),
            ),
            new Promise<never>((_, reject) =>
              setTimeout(
                () => reject(new Error('Redis connection timeout')),
                3000,
              ),
            ),
          ]);
          return redis;
        } catch {
          redis.disconnect();
          console.warn(
            '[Redis] Connection refused. Using in-memory OTP store. Start Redis for production.',
          );
          return new MemoryOtpStore(expirySeconds);
        }
      },
      inject: [ConfigService],
    },
  ],
  exports: [REDIS_CLIENT],
})
export class RedisModule {}
