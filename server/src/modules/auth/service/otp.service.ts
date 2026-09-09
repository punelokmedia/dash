import { Injectable, Inject } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { REDIS_CLIENT, OtpStore } from '../../../config/redis.module';
import { generateOtp } from '../../../common/utils/generate-otp';

/**
 * OTP service - stores and validates OTP in Redis with 5 min expiry
 */
@Injectable()
export class OtpService {
  private readonly prefix: string;
  private readonly expirySeconds: number;
  private readonly otpLength: number;

  constructor(
    @Inject(REDIS_CLIENT) private readonly redis: OtpStore,
    private readonly config: ConfigService,
  ) {
    this.prefix = this.config.get<string>('redis.otpPrefix', 'otp:');
    this.expirySeconds = this.config.get<number>(
      'redis.otpExpirySeconds',
      300,
    );
    this.otpLength = this.config.get<number>('otp.length', 6);
  }

  /** Key with optional scope: otp:, otp:user:, otp:partner: */
  private key(mobile: string, scope = ''): string {
    const digits = mobile.replace(/\D/g, '');
    const scopePart = scope ? `${scope}:` : '';
    return `${this.prefix}${scopePart}${digits}`;
  }

  /** Generate and store OTP for mobile. scope: 'user' | 'partner' for separate flows. */
  async setOtp(mobile: string, scope = ''): Promise<string> {
    const normalized = mobile.replace(/\D/g, '');
    const otp = generateOtp(this.otpLength);
    const k = this.key(normalized, scope);
    await this.redis.setex(k, this.expirySeconds, otp);
    return otp;
  }

  /** Verify OTP for mobile. scope must match the one used in setOtp. */
  async verifyOtp(mobile: string, otp: string, scope = ''): Promise<boolean> {
    const normalized = mobile.replace(/\D/g, '');
    const k = this.key(normalized, scope);
    const stored = await this.redis.get(k);
    if (!stored || stored !== otp) {
      return false;
    }
    await this.redis.del(k);
    return true;
  }

  /** Check if OTP exists (e.g. for rate limiting) */
  async hasOtp(mobile: string, scope = ''): Promise<boolean> {
    const k = this.key(mobile.replace(/\D/g, ''), scope);
    return (await this.redis.exists(k)) === 1;
  }
}
