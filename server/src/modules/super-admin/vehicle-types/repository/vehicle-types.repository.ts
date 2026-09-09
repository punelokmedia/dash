import { Injectable } from '@nestjs/common';
import { VehicleTypes , ServiceType } from '@prisma/client';
import { PrismaService } from '@/config/prisma.service';

@Injectable()
export class VehicleTypesRepository {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: {
    name: string;
    serviceType: ServiceType;
    baseFare: number;
    perKmFare: number;
    perMinuteFare: number;
    capacityKg: number;
    imageUrl?: string;
  }): Promise<VehicleTypes> {
    return this.prisma.vehicleTypes.create({
      data,
    });
  }

  async findAllActive(): Promise<VehicleTypes[]> {
    return this.prisma.vehicleTypes.findMany({
      where: { isActive: true },
      orderBy: { baseFare: 'asc' },
    });
  }

  async findById(id: string): Promise<VehicleTypes | null> {
    return this.prisma.vehicleTypes.findUnique({
      where: { id },
    });
  }

  async update(
    id: string,
    dto: Partial<{
      name: string;
      serviceType: ServiceType;
      baseFare: number;
      perKmFare: number;
      perMinuteFare: number;
      capacityKg: number;
      imageUrl: string;
      isActive: boolean;
    }>
  ): Promise<VehicleTypes> {
    return this.prisma.vehicleTypes.update({
      where: { id },
      data: dto,
    });
  }

  async toggleStatus(id: string, isActive: boolean): Promise<VehicleTypes> {
    return this.prisma.vehicleTypes.update({
      where: { id },
      data: { isActive },
    });
  }

  async updateImage(id: string, imageUrl: string): Promise<VehicleTypes> {
    return this.prisma.vehicleTypes.update({
      where: { id },
      data: { imageUrl },
    });
  }

  async delete(id: string): Promise<VehicleTypes> {
    return this.prisma.vehicleTypes.delete({
      where: { id },
    });
  }
}