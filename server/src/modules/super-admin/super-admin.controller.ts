import {
  Body,
  Controller,
  DefaultValuePipe,
  Get,
  ParseIntPipe,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import { Public } from '../auth/decorators/public.decorator';
import { GetDocumentsDto } from './dto/GetDocumentsDto';
import { PartnerStatusDto } from './dto/partnerStatus.dto';
import { UpdatePartnerStatusDto } from './dto/update-partner-status.dto';
import { SuperAdminJwtGuard } from './guards/jwt-superadmin.guard';
import { SuperAdminService } from './super-admin.service';
import { Roles } from './decorators/roles.decorator';
import { RolesGuard } from './guards/Role.guard';
import { BlockPartnerDto } from './dto/BlockPartnerDto';

/**
 * Super Admin App → /api/super-admin/*
 * Same partner data as Admin (same DB). When admin approves, data is visible here too.
 */
@Controller({ path: 'super-admin', version: '1' })
@Public()
// @UseGuards(SuperAdminJwtGuard,RolesGuard)
// @Roles("superAdmin")
export class SuperAdminController {
  constructor(private readonly superAdminService: SuperAdminService) {}

  @Get()
  info() {
    return { app: 'super-admin', message: 'Super Admin API' };
  }

  @Get('partners/counts')
  getPartnerCounts() {
    return this.superAdminService.getPartnerCounts();
  }

  @Get('partners')
  getPartners(
    @Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number,
    @Query('limit', new DefaultValuePipe(20), ParseIntPipe) limit: number,
  ) {
    return this.superAdminService.getPartners(page, limit);
  }

  @Patch('partner/status')
  updatePartnerStatus(@Body() dto: UpdatePartnerStatusDto) {
    return this.superAdminService.updatePartnerStatus(dto.partner_id, dto.status);
  }

  @Post('partner/documents')
  getDocuments(@Body() dto: GetDocumentsDto){
    return this.superAdminService.getPartnersDocuments(dto);
  }

  @Post('partner/documents/status')
  getDocumentStatus(@Body() dto: GetDocumentsDto){
    return this.superAdminService.getPartnersDocumentStatus(dto);
  }

  @Patch('partner/documents/status')
  setPartnerDocumentStatus(@Body() dto:PartnerStatusDto ){
    return this.superAdminService.setPartnerDocumentStatus(dto);
  }

  @Get('partner/status/count')
  getPartnerStatusDetails(){
    return this.superAdminService.getDetails();
  }

  @Get('partners/all')
  getPartnerDetails(){
    return this.superAdminService.getAllPartners()
  }

  @Post('partner/toggle/isactive')
  togglePartner(@Body() dto:BlockPartnerDto){
    return this.superAdminService.blockPartner(dto)
  }
}
