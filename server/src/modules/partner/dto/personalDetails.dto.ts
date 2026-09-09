import { IsEmail, IsOptional, IsString, MaxLength, MinLength } from "class-validator";

export class personalDetailsDto {
  @IsString()
  @MinLength(2, { message: 'Full name must be at least 2 characters' })
  @MaxLength(100, { message: 'Full name must be maximum 500 characters' })
  fullName: string

  @IsString()
  @IsEmail()
  email:string
 
  @IsString()
  city:string

  @IsString()
  address:string
}