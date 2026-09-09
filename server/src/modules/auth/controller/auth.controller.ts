import { Controller, Post, Body, HttpCode, HttpStatus,Req,
  UseGuards } from '@nestjs/common';
  import { AuthGuard } from '@nestjs/passport';
import { UserAuthService } from '../service/user-auth.service';
import { SendOtpDto } from '../dto/send-otp.dto';
import { VerifyOtpDto } from '../dto/verify-otp.dto';
import { Public } from '../decorators/public.decorator';

/**
 * Dash (e-commerce) user auth → /api/auth (send/verify OTP, JWT for customers).
 */
@Controller({ path: 'auth', version: '1' })
export class AuthController {
  constructor(private readonly userAuthService: UserAuthService) {}

  @Public()
  @Post('check-user')
  @HttpCode(HttpStatus.OK)
  async checkUser(@Body() dto: SendOtpDto) {
    const result = await this.userAuthService.checkUser(dto);
    return { success: true, ...result };
  }

  @Public()
  @Post('send-otp')
  @HttpCode(HttpStatus.OK)
  async sendOtp(@Body() dto: SendOtpDto) {
    const result = await this.userAuthService.sendOtp(dto);
    return { success: true, ...result };
  }

  @Public()
  @Post('verify-otp')
  @HttpCode(HttpStatus.OK)
  async verifyOtp(@Body() dto: VerifyOtpDto) {
    const result = await this.userAuthService.verifyOtp(dto);
    return { success: true, ...result };
  }

   @Public()
  @Post('refresh')
  @HttpCode(HttpStatus.OK)
  async refresh(@Body() body: { refresh_token: string }) {
    return this.userAuthService.refresh(body.refresh_token);
  }
   @Post('logout')
  @UseGuards(AuthGuard('jwt'))
  async logout(@Req() req: any, @Body() body: { refresh_token: string }) {
    return this.userAuthService.logout(req.user.id, body.refresh_token);
  }
}

 
