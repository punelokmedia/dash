import { IsNotEmpty, IsString } from "class-validator";

export class PartnerStatusDto {

    @IsString()
    @IsNotEmpty()
    partner_id:string

    @IsString()
    @IsNotEmpty()
    aadhaar: string

    @IsString()
    @IsNotEmpty()
    panCard: string

    @IsString()
    @IsNotEmpty()
    licence: string

    @IsString()
    @IsNotEmpty()
    bank: string

    @IsString()
    @IsNotEmpty()
    vehicleDocument: string

    @IsString()
    @IsNotEmpty()
    status:string

}