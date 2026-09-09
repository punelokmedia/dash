import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { AuthRepository } from '../repository/auth.repository';
import { OtpService } from './otp.service';
import { OtpDeliveryService } from './otp-delivery.service';
import { SendOtpDto } from '../dto/send-otp.dto';
import { VerifyOtpDto } from '../dto/verify-otp.dto';
import { DeliveryPartner } from '@prisma/client';

export interface JwtPayload {
  sub: string;
  mobile: string;
  type: 'partner' | 'admin' | 'user';
}

export interface AuthResult {
  access_token: string;
  partner: {
    id: string;
    mobile_number: string;
    full_name: string | null;
    status: string;
    is_new: boolean;
  };
}

/**
 * Auth service: OTP send/verify and JWT issuance.
 * OTP delivery (console vs MSG91) is delegated to OtpDeliveryService.
 */
@Injectable()
export class AuthService {
  constructor(
    private readonly authRepository: AuthRepository,
    private readonly otpService: OtpService,
    private readonly otpDelivery: OtpDeliveryService,
    private readonly jwtService: JwtService,
  ) {}

  /** Send OTP for partner (delivery app). Uses scope 'partner' so same mobile can have user OTP. */
  async sendOtp(dto: SendOtpDto): Promise<{ message: string; dev_otp?: string }> {
    const normalized = this.authRepository.normalizeMobile(dto.mobile_number);
    const otp = await this.otpService.setOtp(normalized, 'partner');
    const result = await this.otpDelivery.deliver(normalized, otp);
    return {
      message: result.message,
      ...(result.devOtp != null && { dev_otp: result.devOtp }),
    };
  }

  /** Verify OTP for partner, create partner if new, update last login, return JWT. */
  async verifyOtp(dto: VerifyOtpDto): Promise<AuthResult> {
    const normalized = this.authRepository.normalizeMobile(dto.mobile_number);
    const valid = await this.otpService.verifyOtp(normalized, dto.otp, 'partner');
    if (!valid) {
      throw new UnauthorizedException('Invalid or expired OTP');
    }

    let partner = await this.authRepository.findByMobile(normalized);
    let isNew = false;
    if (!partner) {
      partner = await this.authRepository.createPartner(normalized);
      isNew = true;
    } else {
      await this.authRepository.updateLastLogin(partner.id);
    }

    const payload: JwtPayload = {
      sub: partner.id,
      mobile: partner.mobileNumber,
      type: 'partner',
    };
    const access_token = this.jwtService.sign(payload);

    return {
      access_token,
      partner: {
        id: partner.id,
        mobile_number: partner.mobileNumber,
        full_name: partner.fullName,
        status: partner.status,
        is_new: isNew,
      },
    };
  }

  /** Validate partner from JWT payload (used by guard) */
  async validatePartner(payload: JwtPayload): Promise<DeliveryPartner | null> {
    return this.authRepository.findByMobile(payload.mobile);
  }
}
