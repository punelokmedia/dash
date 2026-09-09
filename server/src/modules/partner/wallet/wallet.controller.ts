import { Body, Controller, Get, Param, Post, Query, Req } from "@nestjs/common";
import { WalletService } from "./wallet.service";
import { GetTransactionsDto } from "./dto/get-transactions.dto";
import { WithdrawDto } from "./dto/withdraw-dto";

@Controller({ path: "partner", version: "1" })
export class WalletController {
  constructor(private readonly service: WalletService) {}

  @Get("wallet-balance")
  async getBalance(@Req() req: any) {
    return await this.service.getBalance(req.user.id);
  }

  @Post("wallet-create")
  async createWallet(@Body() body: any) {
    return await this.service.getOrCreateWalletDirect(body.driverId);
  }

  @Get("wallet-history")
  async getHistory(@Req() req: any, @Query() query: GetTransactionsDto) {
    return this.service.getTransactions(req.user.id, query);
  }

  @Get("wallet-transaction/:id")
  async getTransaction(@Param("id") id: string) {
    return await this.service.getTransactionById(id);
  }

  @Post("withdraw-request")
  requestDriverWithdrawal(@Req() req: any, @Body() dto: WithdrawDto) {
    const user = req.user;

    return this.service.requestDriverWithdrawal(user.id, dto);
  }
}
