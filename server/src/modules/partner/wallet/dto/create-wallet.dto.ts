import { IsUUID } from "class-validator";

export class CreateWalletDTO {
  @IsUUID()
  driverId: string;
}