import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../config/prisma.service';
import { DeliveryPartner } from '@prisma/client';
import { GetDocumentsDto } from './dto/GetDocumentsDto';
import { superAdminRepository } from './repository/superAdmin.repository';
import { PartnerStatusDto } from './dto/partnerStatus.dto';
import { BlockPartnerDto } from './dto/BlockPartnerDto';

/**
 * Super Admin App – platform-wide; same partner data as Admin (same DB).
 * When admin approves a partner, data is stored in delivery_partners and visible to both Admin and Super Admin.
 */
@Injectable()
export class SuperAdminService {
  constructor(
    private readonly superAdminRepository:superAdminRepository,
    private readonly prisma: PrismaService
  ) {}

  async getPartnerCounts(): Promise<{
    total: number;
    pending: number;
    approved: number;
    rejected: number;
  }> {
    const [total, pending, approved, rejected] = await Promise.all([
      this.prisma.deliveryPartner.count(),
      this.prisma.deliveryPartner.count({ where: { status: 'pending' } }),
      this.prisma.deliveryPartner.count({ where: { status: 'approved' } }),
      this.prisma.deliveryPartner.count({ where: { status: 'rejected' } }),
    ]);
    return { total, pending, approved, rejected };
  }

  async getPartners(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [partners, total] = await Promise.all([
      this.prisma.deliveryPartner.findMany({
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.deliveryPartner.count(),
    ]);
    const items = partners.map((p: DeliveryPartner) => ({
      id: p.id,
      mobile_number: p.mobileNumber,
      full_name: p.fullName,
      status: p.status,
      is_active: p.isActive,
      is_online: p.isOnline,
      created_at: p.createdAt,
    }));
    return {
      items,
      total,
      page,
      limit,
      total_pages: Math.ceil(total / limit),
    };
  }

  async updatePartnerStatus(
    partnerId: string,
    status: 'pending' | 'approved' | 'rejected',
  ) {
    const partner = await this.prisma.deliveryPartner.findUnique({
      where: { id: partnerId },
    });
    if (!partner) throw new NotFoundException('Partner not found');
    const updated = await this.prisma.deliveryPartner.update({
      where: { id: partnerId },
      data: { status },
    });
    return { id: updated.id, status: updated.status };
  }

  async getPartnersDocuments(dto: GetDocumentsDto){
    return this.superAdminRepository.getPartnerDocuments(dto);
  }

  async getPartnersDocumentStatus(dto: GetDocumentsDto){
    return this.superAdminRepository.getPartnerDocumentStatus(dto);
  }

  async setPartnerDocumentStatus(dto:PartnerStatusDto){
    return this.superAdminRepository.setPartnerDocumentStatus(dto)
  }

  async getDetails(){
    return this.superAdminRepository.getPartnerStatusDetails()
  }

  getAllPartners(){
    return this.superAdminRepository.getAllPartners()
  }

  blockPartner(dto:BlockPartnerDto){
    return this.superAdminRepository.blockPartner(dto)
  }
}
