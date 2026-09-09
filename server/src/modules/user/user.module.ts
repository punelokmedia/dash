import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { UserRepository } from './repository/user.repository';
import { PaymentModule } from './payment/payment.module';
import { PaymentService } from './payment/payment.service';
import { BookingModule } from "./booking/booking.module";
import { WalletModule } from '../partner/wallet/wallet.module';

/**
 * User App (Dash e-commerce) → /api/user/*
 */
@Module({
  imports: [PaymentModule,BookingModule,WalletModule],
  controllers: [UserController],
  providers: [UserService, UserRepository, PaymentService],
  exports: [UserService, UserRepository],
 
})
export class UserModule {}
