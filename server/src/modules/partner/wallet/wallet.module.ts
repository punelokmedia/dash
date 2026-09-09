import { Module } from "@nestjs/common";
import { WalletService } from "./wallet.service";
import { WalletController } from "./wallet.controller";
import { WalletRepository } from "./repository/wallet.repository"; 

@Module({
  controllers: [WalletController],
  providers: [WalletService, WalletRepository],
  exports: [WalletService], 
})
export class WalletModule {}