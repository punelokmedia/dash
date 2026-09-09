import { IsNotEmpty, IsString, Length, MaxLength } from 'class-validator';

/**
 * DTO for updating partner bank details
 */
export class UpdateBankDto {
  @IsNotEmpty({ message: 'Account number is required' })
  @IsString()
  @Length(9, 18, { message: 'Account number must be 9-18 digits' })
  account_number: string;

  @IsNotEmpty({ message: 'IFSC code is required' })
  @IsString()
  @Length(11, 11, { message: 'IFSC code must be 11 characters' })
  ifsc_code: string;

  @IsNotEmpty({ message: 'Bank name is required' })
  @IsString()
  @MaxLength(100)
  bank_name: string;

  @IsNotEmpty({ message: 'Bank A/C holders name is required' })
  @IsString()
  @MaxLength(100)
  account_holder_name: string;
}
