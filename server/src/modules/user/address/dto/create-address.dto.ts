import {
  IsString,
  IsOptional,
  IsNumber,
  IsBoolean,
  Length,
  Matches,
  IsLatitude,
  IsLongitude,
  IsIn
} from "class-validator"

import { Type } from "class-transformer"

export class CreateAddressDto {

  @IsString({ message: "Label must be a string" })
  @Length(2, 20, { message: "Label must be between 2 and 20 characters" })
  label: string


  @IsString({ message: "Name must be a string" })
  @Length(2, 50, { message: "Name must be between 2 and 50 characters" })
  name: string


 @IsString()
@Matches(/^(?:\+91|91)?[6-9]\d{9}$/, {
  message: 'Phone number must be a valid Indian mobile number',
})
phone: string;


  @IsOptional()
  @IsString()
  @Length(1, 100)
  house?: string

@IsOptional()
@IsString()
@Length(5, 200, {
  message: "Address must be between 5 and 200 characters"
})
address?: string;

  @IsOptional()
  @Matches(/^\d{6}$/, {
    message: "Pincode must be 6 digits"
  })
  pincode?: string


  @IsOptional()
  @Type(() => Number)
  @IsLatitude({
    message: "Latitude must be valid"
  })
  latitude?: number


  @IsOptional()
  @Type(() => Number)
  @IsLongitude({
    message: "Longitude must be valid"
  })
  longitude?: number


  @IsOptional()
  @IsBoolean({
    message: "isDefault must be true or false"
  })
  isDefault?: boolean

  @IsOptional()
  @IsIn(['home', 'work', 'other'], { message: 'Type must be home, work, or other' })
  type?: 'home' | 'work' | 'other'; 
}