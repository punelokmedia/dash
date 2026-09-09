import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { UserModule } from '../user/user.module';
import { AuthController } from './controller/auth.controller';
import { PartnerAuthController } from './controller/partner-auth.controller';
import { AuthRepository } from './repository/auth.repository';
import { AuthService } from './service/auth.service';
import { OtpDeliveryService } from './service/otp-delivery.service';
import { OtpService } from './service/otp.service';
import { SmsService } from './service/sms.service';
import { UserAuthService } from './service/user-auth.service';
import { JwtStrategy } from './strategies/jwt.strategy';
import { SuperAdminAuthController } from './controller/super-admin.controller';
import { SuperAdminAuthService } from './service/super-admin-auth.service';
import { NodemailerModule } from '@/config/nodemailer/nodemailer.module';

@Module({
  imports: [
    UserModule,
    NodemailerModule,
    PassportModule.register({ defaultStrategy: 'jwt' }),
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('jwt.secret'),
        signOptions: {
          expiresIn: config.get<string>('jwt.expiresIn'),
        },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController, PartnerAuthController, SuperAdminAuthController],
  providers: [
    AuthService,
    UserAuthService,
    OtpService,
    OtpDeliveryService,
    SmsService,
    AuthRepository,
    JwtStrategy,
    SuperAdminAuthService
  ],
  exports: [AuthService, UserAuthService, JwtModule],
})
export class AuthModule {}
