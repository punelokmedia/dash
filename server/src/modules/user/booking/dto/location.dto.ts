import { IsLatitude, IsLongitude, IsNotEmpty } from "class-validator"
import { Type } from "class-transformer"

export class LocationDto {

  @IsNotEmpty({ message: "Latitude is required" })
  @Type(() => Number)
  @IsLatitude({ message: "Latitude must be a valid coordinate" })
  latitude: number

  @IsNotEmpty({ message: "Longitude is required" })
  @Type(() => Number)
  @IsLongitude({ message: "Longitude must be a valid coordinate" })
  longitude: number

}