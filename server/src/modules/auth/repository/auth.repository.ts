import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../config/prisma.service';
import { DeliveryPartner } from '@prisma/client';

/**
 * Auth repository - data access for auth-related operations
 */
@Injectable()
export class AuthRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findByMobile(mobileNumber: string): Promise<DeliveryPartner | null> {
    const normalized = this.normalizeMobile(mobileNumber);
    return this.prisma.deliveryPartner.findUnique({
      where: { mobileNumber: normalized },
    });
  }

  async createPartner(mobileNumber: string): Promise<DeliveryPartner> {
    const normalized = this.normalizeMobile(mobileNumber);
    return this.prisma.deliveryPartner.create({
      data: {
        mobileNumber: normalized,
        status: 'pending',
      },
    });
  }

  async findSuperAdmin(email:string){
    return await this.prisma.admin.findFirst({
      where:{
        email
      }
    })
  }

  async updateLastLogin(partnerId: string): Promise<void> {
    await this.prisma.deliveryPartner.update({
      where: { id: partnerId },
      data: { lastLogin: new Date() },
    });
  }

  /** Normalize to 10-digit without country code for storage */
  normalizeMobile(mobile: string): string {
    const digits = mobile.replace(/\D/g, '');
    return digits.length === 12 && digits.startsWith('91')
      ? digits.slice(2)
      : digits.length === 10
        ? digits
        : mobile;
  }
}
