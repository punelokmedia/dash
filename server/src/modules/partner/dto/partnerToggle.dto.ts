import { IsBoolean, IsEmail, IsString, MaxLength, MinLength } from "class-validator";

export class togglePartnerDto {
 
  @IsBoolean()
  IsOnline:boolean;
}