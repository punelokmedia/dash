import { IsNumber, Min } from "class-validator";

export class DebitDto {
  @IsNumber()
  @Min(1)
  amount: number;
}