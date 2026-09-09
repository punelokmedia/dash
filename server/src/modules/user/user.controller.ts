import { Controller, Post, Body, UseGuards,Get, Req,  } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { UserOnlyGuard } from '../auth/guards/user-only.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { UserService } from './user.service';
import { UpdateProfileDto } from './dto/update-profile.dto';
import { User } from '@prisma/client';
import { gstinDto } from './dto/gstin.dto';

/**
 * Dash (e-commerce) User App → /api/user/*
 */
interface AuthRequest extends Request {
  user: {
    id: string;
    mobile: string;
    type: string;
  };
}

@UseGuards(AuthGuard('jwt'))
@Controller({ path: 'user', version: '1' })
export class UserController {

  constructor(private readonly userService: UserService) {}

  @Post('create-account')
  @UseGuards(UserOnlyGuard)
  createAccount(
    @CurrentUser() user: User,
    @Body() dto: UpdateProfileDto,
  ) {
    return this.userService.updateProfile(user.id, {
      full_name: dto.full_name,
      email: dto.email,
      using_for: dto.using_for,
    });
  }
 @Get('profile')
  @UseGuards(AuthGuard('jwt'))
  async getProfile(@Req() req: Request) {
    const userId = (req as any).user.id;
    return this.userService.getProfile(userId);
  }
 

   @Get('basic-info')
  async getBasicProfile(@Req() req: AuthRequest) {
    const fullProfile = await this.userService.getProfile(req.user.id);

    return {
      full_name: fullProfile.full_name,
      email: fullProfile.email,
      profile_photo: fullProfile.profile_photo,
    };
  }
@Post('add-gstin')
@UseGuards(UserOnlyGuard)
addGstin(
  @CurrentUser() user: User,
  @Body() dto: gstinDto,
) {
  return this.userService.addGstin(user.id, dto.gstin);
}


}
  

  

