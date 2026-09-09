import { Module } from "@nestjs/common";
import { PaymentController } from "./payment.controller";
import { PaymentService } from "./payment.service";
import { RazorpayProvider } from "./providers/razorpay.provider";
import { PaymentRepository } from "./repository/payment.repository";
import { WalletModule } from "@/modules/partner/wallet/wallet.module";

@Module({
  imports: [WalletModule],
  controllers: [PaymentController],
  providers: [PaymentService, RazorpayProvider, PaymentRepository],
  exports: [PaymentService, PaymentRepository, RazorpayProvider],
})
export class PaymentModule {}
