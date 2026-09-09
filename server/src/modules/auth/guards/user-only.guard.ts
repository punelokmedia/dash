import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';
import { User } from '@prisma/client';

/**
 * Use after JwtAuthGuard. Ensures request.user is a Dash User (e-commerce), not a delivery partner.
 */
@Injectable()
export class UserOnlyGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<{ user?: User }>();
    const user = request.user;
    if (!user) {
      throw new ForbiddenException('Authentication required');
    }
    if (!('role' in user)) {
      throw new ForbiddenException('User access only');
    }
    return true;
  }
}
