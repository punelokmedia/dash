import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { AuthService, JwtPayload } from '../service/auth.service';
import { UserAuthService } from '../service/user-auth.service';
import { DeliveryPartner, User } from '@prisma/client';

/**
 * JWT strategy – validates token and attaches either User (Dash) or DeliveryPartner to request.
 */
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(
    private readonly config: ConfigService,
    private readonly authService: AuthService,
    private readonly userAuthService: UserAuthService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get<string>('jwt.secret'),
    });
  }

  async validate(payload: JwtPayload): Promise<User | DeliveryPartner> {
    if (payload.type === 'user') {
      const user = await this.userAuthService.validateUser(payload as { sub: string; mobile: string; type: 'user' });
      if (!user) throw new UnauthorizedException('User not found');
      if (!user.isActive) throw new UnauthorizedException('Account is deactivated');
      return user;
    }
    const partner = await this.authService.validatePartner(payload);
    if (!partner) throw new UnauthorizedException('Partner not found');
    if (!partner.isActive) throw new UnauthorizedException('Account is deactivated');
    return partner;
  }
}
