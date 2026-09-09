import { WalletService } from "@/modules/partner/wallet/wallet.service";
import { Body, Controller, Get, Param, Post, Query, Req } from "@nestjs/common";
import { RewardsPaymentService } from "./rewards-payment.service";
import { HandleTransactionDto } from "./dto/handle-transaction.dto";
import { AdminPaymentHistoryDto } from "./dto/admin-payment-history.dto";

@Controller("admin")
export class RewardsPaymentController {
  constructor(private readonly service: RewardsPaymentService) {}

  @Post("withdraw-approve")
  approve(@Body() body: any, @Req() req: any) {
    return this.service.processWithdrawal(body.requestId, req.user.id);
  }

  @Post("reject-withdrawal")
  rejectWithdrawal(@Body() body: any) {
    return this.service.rejectWithdrawal(body.requestId, body.reason);
  }

  @Post("wallet-transaction")
  handleTransaction(@Body() body: HandleTransactionDto, @Req() req: any) {
    return this.service.handleTransaction({
      ...body,
      adminId: req.user.id,
    });
  }

  @Get("payment-history")
  getAdminPayments(@Query() query: AdminPaymentHistoryDto) {
    return this.service.getAdminPaymentHistory(query);
  }

  @Get("payment/:id")
  getDetails(@Param("id") id: string) {
    return this.service.getTransactionDetails(id);
  }

  // @Post("reward")
  // reward(@Body() body: any, @Req() req: any) {
  //   return this.service.giveReward(
  //     body.driverId,
  //     body.amount,
  //     body.description,
  //     body.reason,
  //     req.user.id,
  //   );
  // }

  // @Post("adjustment-credit")
  // credit(@Body() body: any, @Req() req: any) {
  //   return this.service.giveAdjustment(
  //     body.driverId,
  //     body.amount,
  //     body.reason,
  //     body.description,
  //     req.user.id,
  //   );
  // }

  // @Post("penalty")
  // penalty(@Body() body: any, @Req() req: any) {
  //   return this.service.applyPenalty(
  //     body.driverId,
  //     body.amount,
  //     body.description,
  //     req.user.id,
  //   );
  // }

  // @Post("adjust")
  // adjust(@Body() body: any, @Req() req: any) {
  //   return this.service.adjustWallet(
  //     body.driverId,
  //     body.amount,
  //     body.type,
  //     body.description,
  //     body.reason,
  //     req.user.id,
  //   );
  // }
}
