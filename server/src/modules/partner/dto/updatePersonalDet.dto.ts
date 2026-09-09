import { IsEmail, IsNotEmpty, IsString, MaxLength, MinLength } from "class-validator";

export class updatePersonalDetailsDto {

  @IsString()
  @IsEmail()
  @IsNotEmpty()
  email:string

  @IsString()
  @IsNotEmpty()
  mobile_number:string

  @IsString()
  @IsNotEmpty()
  address:string
}