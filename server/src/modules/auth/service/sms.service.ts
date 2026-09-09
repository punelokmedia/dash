import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

const MSG91_SEND_OTP_URL = 'https://api.msg91.com/api/sendotp.php';
const REQUEST_TIMEOUT_MS = 10_000;

/**
 * Production OTP delivery via MSG91 (India). DLT compliant.
 * Used only when NODE_ENV=production; dev uses console via OtpDeliveryService.
 */
@Injectable()
export class SmsService {
  constructor(private readonly config: ConfigService) {}

  isConfigured(): boolean {
    return Boolean(this.config.get<string>('msg91.authKey'));
  }

  /** Send OTP to Indian mobile via MSG91. Expects 10-digit number; prefixes 91. */
  async sendOtp(mobile10: string, otp: string): Promise<void> {
    const authKey = this.config.get<string>('msg91.authKey');
    if (!authKey) return;

    const sender = this.config.get<string>('msg91.senderId') ?? 'DELIVR';
    const otpExpiry = this.config.get<number>('msg91.otpExpiryMinutes') ?? 5;
    const international = `91${mobile10.replace(/\D/g, '').slice(-10)}`;

    const params = new URLSearchParams({
      authkey: authKey,
      mobile: international,
      otp,
      sender,
      otp_expiry: String(otpExpiry),
      otp_length: '6',
      message: `Your verification code is ##OTP##. Valid for ${otpExpiry} min.`,
    });

    const url = `${MSG91_SEND_OTP_URL}?${params.toString()}`;
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS);
    try {
      const res = await fetch(url, { signal: controller.signal });
      clearTimeout(timeoutId);
      const data = (await res.json()) as { type?: string; message?: string };
      if (data?.type !== 'success') {
        throw new Error(data?.message ?? `MSG91: ${JSON.stringify(data)}`);
      }
    } catch (err) {
      clearTimeout(timeoutId);
      throw err;
    }
  }
}
