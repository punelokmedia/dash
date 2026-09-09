import { Module } from '@nestjs/common';
import { PrismaModule } from '../../config/prisma.module';
import { SuperAdminController } from './super-admin.controller';
import { SuperAdminService } from './super-admin.service';
import { VehicleTypesController } from './vehicle-types/vehicle-types.controller';
import { VehicleTypesModule } from './vehicle-types/vehicle-types.module';
import { superAdminRepository } from './repository/superAdmin.repository';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { RewardsPaymentModule } from './rewards-payment/rewards-payment.module';

/**
 * Super Admin App → /api/super-admin/*
 * Same partner list/counts/status as Admin; data stored once, visible to both.
 */
@Module({
  imports: [
    PrismaModule,
    VehicleTypesModule,
    RewardsPaymentModule,

    JwtModule.registerAsync({
      imports: [ConfigModule], // ✅ important
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('jwt.secret'),
        signOptions: {
          expiresIn: config.get<string>('jwt.expiresIn'),
        },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [SuperAdminController],
  providers: [SuperAdminService, superAdminRepository],
})
export class SuperAdminModule {}