import {
  IsNumber,
  Min,
  IsOptional,
  IsString,
  IsNotEmpty,
  IsEnum,
  IsUUID,
} from "class-validator";
import { Type } from "class-transformer";

enum WalletCreditType {
  CREDIT = "CREDIT",
  REWARD = "REWARD",
}

export class CreditDto {
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  amount: number;

  @IsUUID()
  driverId: string;

  @IsOptional()
  @IsEnum(WalletCreditType)
  type?: WalletCreditType;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  referenceId?: string;

  @IsOptional()
  @IsString()
  @IsNotEmpty()
  description?: string;
}
