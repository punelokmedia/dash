import {
  IsNumber,
  IsEnum,
  IsOptional,
  IsString,
  Min,
  ValidateIf,
  Matches,
  Length,
} from "class-validator";
import { Type } from "class-transformer";

export enum WithdrawMethod {
  UPI = "UPI",
  BANK = "BANK",
}

export class WithdrawDto {
  @Type(() => Number)
  @IsNumber({}, { message: "Amount must be a number" })
  @Min(1, { message: "Amount must be greater than 0" })
  amount: number;

  @IsEnum(WithdrawMethod, {
    message: "Method must be either UPI or BANK",
  })
  method: WithdrawMethod;

  // =========================
  // UPI VALIDATION
  // =========================
  @ValidateIf((o) => o.method === WithdrawMethod.UPI)
  @IsString({ message: "UPI ID must be a string" })
  @Matches(/^[\w.-]+@[\w.-]+$/, {
    message: "Invalid UPI ID format",
  })
  upiId?: string;

  // =========================
  // BANK VALIDATION
  // =========================
  @ValidateIf((o) => o.method === WithdrawMethod.BANK)
  @IsString({ message: "Account number must be a string" })
  @Length(9, 18, {
    message: "Account number must be between 9 and 18 digits",
  })
  accountNumber?: string;

  @ValidateIf((o) => o.method === WithdrawMethod.BANK)
  @IsString({ message: "IFSC code must be a string" })
  @Matches(/^[A-Z]{4}0[A-Z0-9]{6}$/, {
    message: "Invalid IFSC code",
  })
  ifscCode?: string;

  @ValidateIf((o) => o.method === WithdrawMethod.BANK)
  @IsString({ message: "Account holder name must be a string" })
  @Length(2, 100, {
    message: "Account holder name must be between 2 and 100 characters",
  })
  accountHolderName?: string;

  @ValidateIf((o) => o.method === WithdrawMethod.BANK)
  @IsString({ message: "Bank name must be a string" })
  @Length(2, 100, {
    message: "Bank name must be between 2 and 100 characters",
  })
  bankName?: string;
}