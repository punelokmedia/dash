import { IsOptional, IsString, IsEmail, MaxLength, Matches, ValidateIf } from 'class-validator';

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @MaxLength(200)
  full_name?: string;

  @IsOptional()
  @IsString()
  @MaxLength(200)
  using_for?: string;

  @IsOptional()
  @IsString()
  @MaxLength(320)
  @Matches(
    /(^\S+@\S+\.\S+$)|(^\d{10}$)/,
    { message: 'email must be a valid email or 10 digit phone number' },
  )
  email?: string;

  @IsOptional()
  @IsString()
  @MaxLength(300)
  address_line1?: string;

  @IsOptional()
  @IsString()
  @MaxLength(300)
  address_line2?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  city?: string;

  @IsOptional()
  @IsString()
  @MaxLength(100)
  state?: string;

  @IsOptional()
  @ValidateIf((_, v) => v != null && String(v).trim() !== '')
  @IsString()
  @MaxLength(10)
  @Matches(/^\d{6}$/, { message: 'Pincode must be 6 digits' })
  pincode?: string;

  @IsOptional()
  @IsString()
  @MaxLength(150)
  landmark?: string;
}
