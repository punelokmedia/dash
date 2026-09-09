import { Module } from "@nestjs/common";
import { PartnerController } from "./partner.controller";
import { PartnerService } from "./partner.service";
import { PartnerRepository } from "./repository/partner.repository";
import { S3UploadService } from "./s3-upload.service";
import { WalletModule } from "./wallet/wallet.module";
import { RazorpayProvider } from "../user/payment/providers/razorpay.provider";

@Module({
  controllers: [PartnerController],
  providers: [PartnerService, PartnerRepository, S3UploadService, RazorpayProvider ],
  exports: [PartnerService],
  imports: [WalletModule],
})
export class PartnerModule {}
