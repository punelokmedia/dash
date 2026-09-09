import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../config/prisma.service';
import { DeliveryPartner } from '@prisma/client';

/**
 * Admin repository - list partners, update status
 */
@Injectable()
export class AdminRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findAll(skip = 0, take = 20): Promise<DeliveryPartner[]> {
    return this.prisma.deliveryPartner.findMany({
      skip,
      take,
      orderBy: { createdAt: 'desc' },
    });
  }

  async count(): Promise<number> {
    return this.prisma.deliveryPartner.count();
  }

  async countByStatus(): Promise<{ total: number; pending: number; approved: number; rejected: number }> {
    const [total, pending, approved, rejected] = await Promise.all([
      this.prisma.deliveryPartner.count(),
      this.prisma.deliveryPartner.count({ where: { status: 'pending' } }),
      this.prisma.deliveryPartner.count({ where: { status: 'approved' } }),
      this.prisma.deliveryPartner.count({ where: { status: 'rejected' } }),
    ]);
    return { total, pending, approved, rejected };
  }

  async updateStatus(
    id: string,
    status: 'pending' | 'approved' | 'rejected',
  ): Promise<DeliveryPartner> {
    return this.prisma.deliveryPartner.update({
      where: { id },
      data: { status },
    });
  }

  async findById(id: string): Promise<DeliveryPartner | null> {
    return this.prisma.deliveryPartner.findUnique({
      where: { id },
    });
  }
}
