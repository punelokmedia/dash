import { Transform } from "class-transformer";
import { IsEnum, IsOptional, IsString } from "class-validator";

export class GetTransactionsDto {
  @IsOptional()
  @Transform(({ value }) => Number(value))
  page?: number = 1;

  @IsOptional()
  @Transform(({ value }) => Number(value))
  limit?: number = 10;

  @IsOptional()
  @IsEnum(["asc", "desc"])
  sort?: "asc" | "desc" = "desc";

  @IsOptional()
  @IsEnum(["CREDIT", "DEBIT", "REWARD", "PENALTY", "ADJUSTMENT"])
  type?: any;

  @IsOptional()
  @IsEnum(["IN", "OUT"])
  direction?: any;

  @IsOptional()
  @IsString()
  dateFilter?: "THIS_MONTH" | "LAST_30_DAYS" | "LAST_90_DAYS";

  @IsOptional()
  @IsString()
  startDate?: string;

  @IsOptional()
  @IsString()
  endDate?: string;

  @IsOptional()
  @Transform(({ value }) => Number(value))
  minAmount?: number;

  @IsOptional()
  @Transform(({ value }) => Number(value))
  maxAmount?: number;

  @IsOptional()
  @IsString()
  paymentMethod?: "UPI" | "CARD" | "NETBANKING" | "WALLET" | "COD";
}