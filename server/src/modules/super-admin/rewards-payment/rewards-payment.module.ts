import { Module } from '@nestjs/common';
import { RewardsPaymentController } from './rewards-payment.controller';
import { RewardsPaymentService } from './rewards-payment.service';
import { WalletService } from '@/modules/partner/wallet/wallet.service';
import { WalletModule } from '@/modules/partner/wallet/wallet.module';

@Module({
  imports: [WalletModule],
  controllers: [RewardsPaymentController],
  providers: [RewardsPaymentService],
})
export class RewardsPaymentModule {}
