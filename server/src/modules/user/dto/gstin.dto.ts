import { IsOptional, IsString, MaxLength } from "class-validator";


export class gstinDto{
     @IsOptional()
      @IsString()
      @MaxLength(15)
      gstin: string;
}