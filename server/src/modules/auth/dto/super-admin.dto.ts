import { IsEmail, IsNotEmpty } from "class-validator";

export class SuperAdminDto {
    @IsEmail()
    @IsNotEmpty()
    email: string;
}
