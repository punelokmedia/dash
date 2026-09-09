import { SetMetadata } from '@nestjs/common';

export const ROLES_KEY = 'roles';

/** Allowed roles for the route (e.g. 'partner', 'admin') */
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);
