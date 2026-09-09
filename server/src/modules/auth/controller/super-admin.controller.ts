import { Body, Controller, Get, Post, Request, Res, UseGuards } from '@nestjs/common';
import { Public } from '../decorators/public.decorator';
import { SuperAdminDto } from '../dto/super-admin.dto';
import { SuperAdminJwtGuard } from '../guards/jwt-superadmin.guard';
import { SuperAdminAuthService } from '../service/super-admin-auth.service';

@Controller({ path: 'auth/super-admin', version: '1' })
export class SuperAdminAuthController {
    constructor(private readonly superAdminAuthService: SuperAdminAuthService) { }

    @Post("signin")
    @Public()
    async generateUrl(@Body() SuperAdminDto: SuperAdminDto) {
        return await this.superAdminAuthService.signin(SuperAdminDto.email);
    }

    @Post("verify")
    @Public()
    @UseGuards(SuperAdminJwtGuard)
    // @UseGuards(AdminOnlyGuard)
    async adminVerification(@Request() req: any) {
        return await this.superAdminAuthService.verifySuperAdmin(req.superAdmin);
    }

    @Post("logout")
    @Public()
    async logout(@Request() req: any, @Res({passthrough:true}) res: any) {
        return await this.superAdminAuthService.logout(req, res)
    }
}
