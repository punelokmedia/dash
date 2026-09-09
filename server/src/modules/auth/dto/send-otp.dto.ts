import { IsNotEmpty, IsString, Matches, Length } from 'class-validator';

/**
 * DTO for Send OTP request
 * Indian mobile: 10 digits, optionally prefixed with +91
 */
export class SendOtpDto {
  @IsNotEmpty({ message: 'Mobile number is required' })
  @IsString()
  @Matches(/^(\+91)?[6-9]\d{9}$/, {
    message: 'Please enter a valid 10-digit Indian mobile number',
  })
  mobile_number: string;
}
