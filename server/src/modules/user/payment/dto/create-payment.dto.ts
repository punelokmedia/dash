import { IsUUID, IsEnum } from "class-validator";
import { PaymentMethod } from "@prisma/client";

export class CreatePaymentDto {
  @IsUUID()
  orderId: string;

  @IsEnum(PaymentMethod, {
    message: "method must be COD | UPI | CARD | NETBANKING | WALLET",
  })
  method: PaymentMethod;
}