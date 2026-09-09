import { Injectable, NotFoundException } from '@nestjs/common';
import { AdminRepository } from './repository/admin.repository';

@Injectable()
export class AdminService {
  constructor(private readonly adminRepository: AdminRepository) {}

  async getPartnerCounts() {
    return this.adminRepository.countByStatus();
  }

  async getPartners(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [partners, total] = await Promise.all([
      this.adminRepository.findAll(skip, limit),
      this.adminRepository.count(),
    ]);
    const items = partners.map((p) => ({
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
    const partner = await this.adminRepository.findById(partnerId);
    if (!partner) throw new NotFoundException('Partner not found');
    const updated = await this.adminRepository.updateStatus(partnerId, status);
    return { id: updated.id, status: updated.status };
  }
}
