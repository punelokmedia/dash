import {
  Controller,
  Get,
  Patch,
  Body,
  Query,
  UseGuards,
  ParseIntPipe,
  DefaultValuePipe,
} from '@nestjs/common';
import { AdminService } from './admin.service';
import { UpdatePartnerStatusDto } from './dto/update-status.dto';
import { AdminGuard } from './guards/admin.guard';
import { Public } from '../auth/decorators/public.decorator';

/**
 * Admin App → /api/admin/*
 */
@Controller({ path: 'admin', version: '1' })
@Public()
@UseGuards(AdminGuard)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('partners/counts')
  async getPartnerCounts() {
    return this.adminService.getPartnerCounts();
  }

  @Get('partners')
  async getPartners(
    @Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number,
    @Query('limit', new DefaultValuePipe(20), ParseIntPipe) limit: number,
  ) {
    return this.adminService.getPartners(page, limit);
  }

  @Patch('partner/status')
  async updatePartnerStatus(@Body() dto: UpdatePartnerStatusDto) {
    return this.adminService.updatePartnerStatus(dto.partner_id, dto.status);
  }
}
