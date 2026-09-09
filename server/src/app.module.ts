import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { APP_FILTER, APP_GUARD, APP_INTERCEPTOR } from '@nestjs/core';
import { JwtAuthGuard } from './modules/auth/guards/jwt-auth.guard';
import configuration from './config/configuration';
import { RedisModule } from './config/redis.module';
import { PrismaModule } from './config/prisma.module';
import { HttpExceptionFilter } from './common/filters/http-exception.filter';
import { ResponseInterceptor } from './common/interceptors/response.interceptor';
import { AuthModule } from './modules/auth/auth.module';
import { PartnerModule } from './modules/partner/partner.module';
import { AdminModule } from './modules/admin/admin.module';
import { UserModule } from './modules/user/user.module';
import { SuperAdminModule } from './modules/super-admin/super-admin.module';
import { PaymentModule } from './modules/user/payment/payment.module';
import { CloudinaryModule } from './config/cloudinary/cloudinary.module';
import { AddressModule } from './modules/user/address/address.module';
import { WalletModule } from './modules/partner/wallet/wallet.module';
import { RewardsPaymentModule } from './modules/super-admin/rewards-payment/rewards-payment.module';


/**
 * Single NestJS Backend – four app boundaries:
 *   Admin App       → /api/admin/*
 *   User App       → /api/user/*
 *   Delivery App   → /api/partner/*  (partner = delivery boy; auth: /api/auth)
 *   Super Admin    → /api/super-admin/*
 */
@Module({
  imports: [
    AddressModule,
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
    RedisModule,
    PrismaModule,
    AuthModule, // Delivery partner OTP login → /api/auth
    PartnerModule, // Delivery App → /api/partner/*
    AdminModule, // Admin App → /api/admin/*
    UserModule, // User App → /api/user/*
    SuperAdminModule, // Super Admin → /api/super-admin/*
    PaymentModule, // User -> api/v1/payment /*
    CloudinaryModule, 
    WalletModule,
    PaymentModule,
    RewardsPaymentModule,
    
  ],
  providers: [
    { provide: APP_FILTER, useClass: HttpExceptionFilter },
    { provide: APP_INTERCEPTOR, useClass: ResponseInterceptor },
    { provide: APP_GUARD, useClass: JwtAuthGuard },
  ],
})
export class AppModule {}
