import {
  Body,
  Controller,
  Get,
  Headers,
  Post,
  Query,
  Req,
} from "@nestjs/common";
import { PaymentService } from "./payment.service";
import { CreatePaymentDto } from "./dto/create-payment.dto";
import { VerifyPaymentDto } from "./dto/verify-payment.dto";

@Controller("payments")
export class PaymentController {
  constructor(private readonly service: PaymentService) {}

  @Post("create-order")
  create(@Body() dto: CreatePaymentDto) {
    return this.service.createOrder(dto);
  }

  @Post("verify")
  verify(@Body() dto: VerifyPaymentDto) {
    return this.service.verifyPayment(dto);
  }

  // @Post("cod-confirm")
  // confirmCOD(@Body() body: { orderId: string }, @Req() req: any) {
  //   return this.service.confirmCOD(body.orderId, req.user.id);
  // }
  
  // @Post("upi-confirm")
  // confirmUPI(@Body() body: { orderId: string }, @Req() req: any) {
  //   return this.service.confirmUPI(body.orderId, req.user.id);
  // }

  @Post("confirm-payment")
  confirm(@Body() body: any, @Req() req: any) {
    return this.service.confirmPayment(body.orderId, req.user.id, body.method);
  }

  @Post("webhook")
  webhook(@Req() req: any, @Headers("x-razorpay-signature") signature: string) {
    return this.service.handleWebhook(req.body, signature);
  }

  @Post("status")
  getStatus(@Body() body: { orderId: string }) {
    return this.service.getPaymentStatus(body.orderId);
  }

  @Post("details")
  getDetails(@Body() body: { orderId: string }) {
    return this.service.getPaymentDetails(body.orderId);
  }

  @Get("history")
  getHistory(@Req() req: any, @Query() query: any) {
    return this.service.getPaymentHistory(req.user.id, query);
  }
}
