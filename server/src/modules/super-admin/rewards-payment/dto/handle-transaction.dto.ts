import {
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Min,
} from "class-validator";
import { WalletTxnType } from "@prisma/client";

export class HandleTransactionDto {
  @IsString()
  @IsNotEmpty()
  driverId: string;

  @IsNumber()
  @Min(1)
  amount: number;

  @IsEnum(WalletTxnType)
  type: WalletTxnType;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsString()
  reason?: string;
}