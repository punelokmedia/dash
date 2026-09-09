import { IsEnum, IsNumber, IsOptional, IsString } from 'class-validator';
import { ServiceType } from '@prisma/client';

export class UpdateVehicalDTO {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsEnum(ServiceType)
  serviceType?: ServiceType;

  @IsOptional()
  @IsNumber()
  baseFare?: number;

  @IsOptional()
  @IsNumber()
  perKmFare?: number;

  @IsOptional()
  @IsNumber()
  perMinuteFare?: number;

  @IsOptional()
  @IsNumber()
  capacityKg?: number;

  @IsOptional()
  isActive?: boolean;
}