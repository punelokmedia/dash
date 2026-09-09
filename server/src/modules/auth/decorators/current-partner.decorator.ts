import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { DeliveryPartner } from '@prisma/client';

/**
 * Extracts current partner from request (set by JwtAuthGuard)
 */
export const CurrentPartner = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): DeliveryPartner => {
    const request = ctx.switchToHttp().getRequest();
    return request.user;
  },
);
