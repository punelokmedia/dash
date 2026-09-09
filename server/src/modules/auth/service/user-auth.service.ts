import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UserRepository } from '../../user/repository/user.repository';
import { OtpService } from './otp.service';
import { OtpDeliveryService } from './otp-delivery.service';
import { SendOtpDto } from '../dto/send-otp.dto';
import { VerifyOtpDto } from '../dto/verify-otp.dto';
import { v4 as uuidv4 } from 'uuid';
import { PrismaService } from 'src/config/prisma.service';
const OTP_SCOPE_USER = 'user';

export interface UserJwtPayload {
  sub: string;
  mobile: string;
  type: 'user';
}

export interface UserAuthResult {
  access_token: string;
  profileCompleted: boolean;
  user: {
    id: string;
    mobile_number: string;
    full_name: string | null;
    email: string | null;
    is_new: boolean;
  };
}

@Injectable()
export class UserAuthService {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly otpService: OtpService,
    private readonly otpDelivery: OtpDeliveryService,
    private readonly jwtService: JwtService,
    private readonly prisma: PrismaService 
  ) {}

  async checkUser(dto: SendOtpDto): Promise<{
    exists: boolean;
    profileCompleted?: boolean;
    user?: {
      id: string;
      mobile_number: string;
      full_name: string | null;
      email: string | null;
    };
  }> {
    const normalized = this.userRepository.normalizeMobile(dto.mobile_number);
    const user = await this.userRepository.findByMobile(normalized);

    if (!user) {
      return { exists: false };
    }

    const profileCompleted = user.fullName != null;

    return {
      exists: true,
      profileCompleted,
      user: {
        id: user.id,
        mobile_number: user.mobileNumber,
        full_name: user.fullName,
        email: user.email,
      },
    };
  }

  async sendOtp(dto: SendOtpDto): Promise<{ message: string; dev_otp?: string }> {
    const normalized = this.userRepository.normalizeMobile(dto.mobile_number);
    const otp = await this.otpService.setOtp(normalized, OTP_SCOPE_USER);
    const result = await this.otpDelivery.deliver(normalized, otp);
    return {
      message: result.message,
      ...(result.devOtp != null && { dev_otp: result.devOtp }),
    };
  }

  async verifyOtp(dto: VerifyOtpDto): Promise<any> {
  const normalized = this.userRepository.normalizeMobile(dto.mobile_number);

  const valid = await this.otpService.verifyOtp(
    normalized,
    dto.otp,
    OTP_SCOPE_USER
  );

  if (!valid) {
    throw new UnauthorizedException('Invalid or expired OTP');
  }

  let user = await this.userRepository.findByMobile(normalized);
  let isNew = false;

  if (!user) {
    user = await this.userRepository.create(normalized);
    isNew = true;
  } else {
    await this.userRepository.updateLastLogin(user.id);
  }

  // ✅ JWT Payload
  const payload: UserJwtPayload = {
    sub: user.id,
    mobile: user.mobileNumber,
    type: 'user',
  };

  // ✅ Access Token (short-lived)
  const access_token = this.jwtService.sign(payload, {
    expiresIn: '60m',
  });

  // ✅ Refresh Token (long-lived)
  const refresh_token = uuidv4();

  await this.prisma.refreshToken.create({
    data: {
      token: refresh_token,
      userId: user.id,
      expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), // 7 days
    },
  });

  const profileCompleted = user.fullName != null;

  return {
    access_token,
    refresh_token, // 🔥 NEW
    profileCompleted,
    user: {
      id: user.id,
      mobile_number: user.mobileNumber,
      full_name: user.fullName,
      email: user.email,
      is_new: isNew,
    },
  };
}
async refresh(refreshToken: string) {

  const tokenData = await this.prisma.refreshToken.findUnique({
    where: { token: refreshToken }
  });

  if (!tokenData || tokenData.isRevoked || tokenData.expiresAt < new Date()) {
    throw new UnauthorizedException('Invalid refresh token');
  }

  const user = await this.userRepository.findById(tokenData.userId);

   // ✅ FIRST check
  if (!user) {
    throw new UnauthorizedException('User not found');
  }


  const payload: UserJwtPayload = {
    sub: user.id,
    mobile: user.mobileNumber,
    type: 'user',
  };

   if (!user) {
    throw new UnauthorizedException('User not found');
  }

  const access_token = this.jwtService.sign(payload, {
    expiresIn: '15m',
  });

  return {
    success: true,
    access_token
  };
}

async logout(userId: string, refreshToken: string) {

  await this.prisma.refreshToken.updateMany({
    where: {
      userId,
      token: refreshToken
    },
    data: {
      isRevoked: true
    }
  });

  return {
    success: true,
    message: "Logged out successfully"
  };
}

  async validateUser(payload: UserJwtPayload) {
    if (payload.type !== 'user') return null;
    return  this.userRepository.findById(payload.sub);
  }
}
