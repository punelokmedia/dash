import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Request, Response } from 'express';

@Injectable()
export class SuperAdminJwtGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<Request>();
    const response = context.switchToHttp().getResponse<Response>();

    const token = this.extractTokenFromHeader(request);
    const token2 = this.extractFromCookie(request)
    const finalToken = token || token2
    if (!finalToken) {
      throw new UnauthorizedException('No token provided');
    }

    try {
      const payload = await this.jwtService.verifyAsync(finalToken);

      request['superAdmin'] = payload;

      response.cookie('token', finalToken, {
        httpOnly: true, 
        maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days in ms
        secure: true, 
        sameSite: 'strict',
      });

      return true;
    } catch (err) {
      throw new UnauthorizedException('Invalid or expired token');
    }
  }

  private extractTokenFromHeader(request: Request): string | undefined {
    const [type, token] = request.headers.authorization?.split(' ') ?? [];
    return type === 'Bearer' ? token : undefined;
  }

  private extractFromCookie(request: any): string | null {
    return request.cookies?.token ?? null;
  }
}
