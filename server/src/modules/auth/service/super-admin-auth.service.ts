import { Injectable, InternalServerErrorException } from '@nestjs/common';
import { AuthRepository } from '../repository/auth.repository';
import { JwtService } from '@nestjs/jwt';
import { NodemailerService } from '@/config/nodemailer/nodemailer.service';

@Injectable()
export class SuperAdminAuthService {
    constructor(private readonly authRepository:AuthRepository,
        public jwtService: JwtService,
        private readonly nodemailerService:NodemailerService
    ){}

     async signin(email: string) {
        const superAdminFound = await this.authRepository.findSuperAdmin(email);
        if(superAdminFound){
            const payload = { id: superAdminFound.id, email: superAdminFound.email,role:superAdminFound.role };
            const Token = await this.jwtService.signAsync(payload);
            if(Token){
                const emailResult = await this.nodemailerService.sendVerificationEmail(email,Token);
                if(emailResult !== null){
                    return {success:true, message: "please check your email..."}
                }else{
                    return {success:false, message: "problem when sending verification email..."}
                }
            }
        }else{
            return {sucess:true, message: "superadmin email not correct..."}
        }
     }

     async verifySuperAdmin(SuperAdmin: string) {
        try {
            if (!SuperAdmin) {
                return { message: "invalid token", statusCode: 400 }
            }
            return { message: "Super Admin verified successfully", statusCode: 200 }
        } catch (error) {
            console.log(error);
        }
     }

     async logout(req:any,res:any){
            const token = req.cookies.token;
            const payload = await this.jwtService.verifyAsync(token);
            if(payload){
                res.clearCookie('token',{
                    httpOnly: true, 
                    secure: true, 
                    sameSite: 'strict',
                })
            }
            return {success:true,message:"logout success..."}
     }
}
