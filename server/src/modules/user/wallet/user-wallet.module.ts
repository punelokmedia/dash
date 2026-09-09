import { Module } from '@nestjs/common';
import { UserWalletService } from './user-wallet.service';
import { UserWalletController } from './user-wallet.controller';

@Module({
  providers: [UserWalletService],
  controllers: [UserWalletController],
  exports: [UserWalletService],
})
export class UserWalletModule {}
