import { IsBoolean, IsNotEmpty, IsString } from 'class-validator';

export class BlockPartnerDto {
  @IsNotEmpty() 
  @IsString()
  partnerId: string;

  @IsNotEmpty() 
  @IsBoolean()
  isActive: boolean;
}
