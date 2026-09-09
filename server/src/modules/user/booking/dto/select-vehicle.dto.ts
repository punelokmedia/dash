import { IsString, IsNotEmpty, IsUUID } from "class-validator"

export class SelectVehicleDto {

  @IsNotEmpty({ message: "Vehicle ID is required" })
  @IsUUID("4", { message: "Vehicle ID must be a valid UUID" })
  vehicleId: string

}