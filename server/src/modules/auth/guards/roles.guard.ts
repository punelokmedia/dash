import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators/roles.decorator';
import { DeliveryPartner } from '@prisma/client';

/**
 * Role guard - restricts access by role (partner | admin)
 * Expects user to be set by JwtAuthGuard (DeliveryPartner for partner)
 */
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(
      ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );
    if (!requiredRoles?.length) {
      return true;
    }
    const { user } = context.switchToHttp().getRequest<{ user: DeliveryPartner }>();
    // For now we only have 'partner' type in JWT. Admin can be added later with separate auth.
    const userRole = user ? 'partner' : undefined;
    if (!userRole || !requiredRoles.includes(userRole)) {
      throw new ForbiddenException('Insufficient permissions');
    }
    return true;
  }
}
