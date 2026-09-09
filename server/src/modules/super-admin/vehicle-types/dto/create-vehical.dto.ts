import { IsEnum, IsNumber, IsString } from 'class-validator';
import { ServiceType } from '@prisma/client';

export class CreateVehicalDTO {
  @IsString()
  name: string;

  @IsEnum(ServiceType)
  serviceType: ServiceType;

  @IsNumber()
  baseFare: number;

  @IsNumber()
  perKmFare: number;

  @IsNumber()
  perMinuteFare: number;

  @IsNumber()
  capacityKg: number;
}