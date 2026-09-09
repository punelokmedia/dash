import {
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
  MinLength
} from 'class-validator';

/**
 * DTO for updating partner vehicle details
 */
export class UpdateVehicleDto {
  @IsNotEmpty({ message: 'Vehicle type is required' })
  @IsString()
  @MinLength(2)
  @MaxLength(20)
  vehicle_type: string;

  @IsNotEmpty({ message: 'Vehicle number is required' })
  @IsString()
  @MinLength(5)
  @MaxLength(20)
  vehicle_number: string;

  @IsNotEmpty({ message: 'Vehicle Registration Number is required' })
  @IsString()
  @MinLength(5)
  @MaxLength(20)
  vehicle_registration_number: string;

  // @IsNotEmpty({ message: 'Aadhaar number is required' })
  // @IsString()
  // @Matches(/^\d{12}$/, { message: 'Aadhaar must be exactly 12 digits' })
  // aadhaar_number: string;

  // @IsOptional()
  // @IsString()
  // @MaxLength(30)
  // license_number?: string;

  @IsNotEmpty()
  @IsString()
  vehicle_body_type:string

  @IsNotEmpty()
  @IsString()
  vehicle_brand_name:string

  @IsNotEmpty()
  @IsString()
  vehicle_fuel_type:string

  @IsNotEmpty()
  @IsString()
  manufacture_in:string

  @IsOptional()
  @IsString()
  vehicle_height:string

  @IsOptional()
  @IsString()
  vehicle_weight:string
  
}
