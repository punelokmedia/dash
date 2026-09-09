import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class GetDocumentsDto {
  @IsNotEmpty() 
  @IsString()
  partner_id?: string;
}
