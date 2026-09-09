import { Injectable, BadGatewayException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { SmsService } from './sms.service';

/** Result of delivering OTP. devOtp only in development (for frontend display). */
export interface OtpDeliveryResult {
  success: boolean;
  devOtp: string | null;
  message: string;
}

/**
 * Single responsibility: decide how OTP is delivered and return consistent result.
 * - Development → Console log + devOtp in response (no SMS, save credits).
 * - Production → MSG91 SMS only; devOtp never returned.
 */
@Injectable()
export class OtpDeliveryService {
  private readonly logger = new Logger(OtpDeliveryService.name);

  constructor(
    private readonly config: ConfigService,
    private readonly smsService: SmsService,
  ) {}

  private get isProduction(): boolean {
    return this.config.get<boolean>('otpDelivery.isProduction', false);
  }

  /**
   * Deliver OTP via console (dev) or MSG91 (prod). Returns result with devOtp only in dev.
   */
  async deliver(normalizedMobile: string, otp: string): Promise<OtpDeliveryResult> {
    if (!this.isProduction) {
      return this.deliverViaConsole(normalizedMobile, otp);
    }
    return this.deliverViaMsg91(normalizedMobile, otp);
  }

  /** Development: log OTP to console, return devOtp for API response. */
  private deliverViaConsole(mobile: string, otp: string): OtpDeliveryResult {
    this.logger.log(`[DEV] OTP for ${mobile}: ${otp}`);
    return {
      success: true,
      devOtp: otp,
      message: 'OTP sent successfully. Valid for 5 minutes.',
    };
  }

  /** Production: send via MSG91. Fails if MSG91 not configured. */
  private async deliverViaMsg91(mobile: string, otp: string): Promise<OtpDeliveryResult> {
    if (!this.smsService.isConfigured()) {
      this.logger.error('Production requires MSG91_AUTH_KEY. Set in .env.');
      throw new BadGatewayException(
        'OTP service not configured. Please contact support.',
      );
    }
    try {
      await this.smsService.sendOtp(mobile, otp);
      return {
        success: true,
        devOtp: null,
        message: 'OTP sent to your mobile. Valid for 5 minutes.',
      };
    } catch (err) {
      this.logger.warn(`MSG91 send failed: ${err instanceof Error ? err.message : err}`);
      throw new BadGatewayException(
        'Failed to send OTP. Please try again.',
      );
    }
  }
}
