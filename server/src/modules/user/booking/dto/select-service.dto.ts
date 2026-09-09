import { IsEnum, IsNotEmpty } from "class-validator"
import { ServiceType } from "@prisma/client"


export class SelectServiceDto {

  @IsNotEmpty({ message: "Service type is required" })
  @IsEnum(ServiceType, { message: "Service type must be WITHIN_CITY or OUTSTATION" })
  serviceType: ServiceType

}