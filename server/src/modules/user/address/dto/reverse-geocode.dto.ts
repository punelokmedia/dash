import { IsOptional,IsLatitude,
  IsLongitude, } from "class-validator"
import { Type } from "class-transformer"

export class ReverseGeocodeDto {
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
}