import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Request } from 'express';

/**
 * Admin guard - validates X-Admin-API-Key header against ADMIN_API_KEY env
 */
@Injectable()
export class AdminGuard implements CanActivate {
  constructor(private readonly config: ConfigService) {}

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<Request>();
    const apiKey = request.headers['x-admin-api-key'];
    const expected = this.config.get<string>('admin.apiKey');
    if (!expected) {
      throw new UnauthorizedException('Admin API not configured');
    }
    if (apiKey !== expected) {
      throw new UnauthorizedException('Invalid admin API key');
    }
    return true;
  }
}
