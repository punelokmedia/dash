import {
  Controller,
  Get,
  Post,
  Body,
  UseGuards,
  Query,
  Request,
  Req,
} from "@nestjs/common";
import { UserWalletService } from "./user-wallet.service";
import { JwtAuthGuard } from "../../auth/guards/jwt-auth.guard";
import { WithdrawalMethod } from "@prisma/client";
import { WithdrawDto } from "@/modules/partner/wallet/dto/withdraw-dto";
import { WalletService } from "@/modules/partner/wallet/wallet.service";

@Controller("user/wallet")
@UseGuards(JwtAuthGuard)
export class UserWalletController {
  constructor(private readonly walletService: UserWalletService) {}

  @Get()
  async getWallet(@Request() req: any) {
    const userId = req.user.id;
    return this.walletService.getWallet(userId);
  }

  @Get("transactions")
  async getTransactions(@Request() req: any) {
    const userId = req.user.id;
    return this.walletService.getTransactions(userId);
  }

  @Post("withdraw-request")
  requestUserWithdrawal(@Req() req: any, @Body() dto: WithdrawDto) {
    const user = req.user;

    return this.walletService.requestUserWithdrawal(user.id, dto);
  }
}
