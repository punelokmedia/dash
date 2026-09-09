import {
  BadRequestException,
  Body,
  Controller,
  Get,
  Post,
  UploadedFile,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { DeliveryPartner } from '@prisma/client';
import type { MulterFile } from '../../types/multer';
import { CurrentPartner } from '../auth/decorators/current-partner.decorator';
import { Roles } from '../auth/decorators/roles.decorator';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { UpdateBankDto } from './dto/bank.dto';
import { personalDetailsDto } from './dto/personalDetails.dto';
import { UpdateProfileDto } from './dto/profile.dto';
import { UpdateVehicleDto } from './dto/vehicle.dto';
import { PartnerService } from './partner.service';
import { togglePartnerDto } from './dto/partnerToggle.dto';
import { updatePersonalDetailsDto } from './dto/updatePersonalDet.dto';

const DOCUMENT_MAX_BYTES = 2 * 1024 * 1024; // 2 MB

/**
 * Delivery App → /api/partner/*
 * MVC: Controller only handles HTTP; delegates to PartnerService.
 */
@Controller({ path: 'partner', version: '1' })
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('partner')
export class PartnerController {
  constructor(private readonly partnerService: PartnerService) {}

  @Get('profile')
  async getProfile(@CurrentPartner() partner: DeliveryPartner) {
    return this.partnerService.getProfile(partner.id);
  }

  @Post('profile')
  async updateProfile(
    @CurrentPartner() partner: DeliveryPartner,
    @Body() dto: UpdateProfileDto,
  ) {
    return this.partnerService.updateProfile(partner.id, dto);
  }

  @Post('upload-photo')
  @UseInterceptors(
    FileInterceptor('photo', {
      limits: { fileSize: 5 * 1024 * 1024 },
    }),
  )
  async uploadProfilePhoto(
    @CurrentPartner() partner: DeliveryPartner,
    @UploadedFile() file: MulterFile,
  ) {
    if (!file) {
      throw new BadRequestException('No file uploaded. Use field name "photo".');
    }
    return this.partnerService.uploadProfilePhoto(partner.id, file,"profile_photo");
  }

  @Post('vehicle')
  async updateVehicle(
    @CurrentPartner() partner: DeliveryPartner,
    @Body() dto: UpdateVehicleDto,
  ) {
    return this.partnerService.updateVehicle(partner.id, dto);
  }

  @Post('toggle/status')
  async toggle(
    @CurrentPartner() partner: DeliveryPartner,
    @Body() dto: togglePartnerDto 
  ){
    return this.partnerService.toglePartnerStatus(partner.id,dto);
  }

  @Get('vehicle')
  async getVehicleDetails(
    @CurrentPartner() partner: DeliveryPartner,
  ) {
    return this.partnerService.getVehicleDetails(partner.id);
  }

  @Post('bank')
  async updateBank(
    @CurrentPartner() partner: DeliveryPartner,
    @Body() dto: UpdateBankDto,
  ) {
    return this.partnerService.updateBank(partner.id, dto);
  }

  @Post('upload-aadhaar-image')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: DOCUMENT_MAX_BYTES } }),
  )
  async uploadAadhaarImage(
    @CurrentPartner() partner: DeliveryPartner,
    @UploadedFile() file: MulterFile,
  ) {
    if (!file) {
      throw new BadRequestException('No file. Use form field "file".');
    }
    return this.partnerService.uploadDocument(partner.id, file, 'aadhaar_image');
  }

  @Post('upload-licence-image')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: DOCUMENT_MAX_BYTES } }),
  )
  async uploadLicenceImage(
    @CurrentPartner() partner: DeliveryPartner,
    @UploadedFile() file: MulterFile,
  ) {
    if (!file) {
      throw new BadRequestException('No file. Use form field "file".');
    }
    return this.partnerService.uploadDocument(partner.id, file, 'licence_image');
  }

  @Post('upload-aadhaar-pdf')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: DOCUMENT_MAX_BYTES } }),
  )
  async uploadAadhaarPdf(
    @CurrentPartner() partner: DeliveryPartner,
    @UploadedFile() file: MulterFile,
  ) {
    if (!file) {
      throw new BadRequestException('No file. Use form field "file".');
    }
    return this.partnerService.uploadDocument(partner.id, file, 'aadhaar_pdf');
  }

  @Post('upload-pan-card')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: DOCUMENT_MAX_BYTES } }),
  )
  async uploadPanCard(
    @CurrentPartner() partner: DeliveryPartner,
    @UploadedFile() file: MulterFile,
  ) {
    if (!file) {
      throw new BadRequestException('No file. Use form field "file".');
    }
    return this.partnerService.uploadDocument(partner.id, file, 'pan_card');
  }

  @Post('upload-vehicle-photo')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: DOCUMENT_MAX_BYTES } }),
  )
  async uploadVehiclePhoto(
    @CurrentPartner() partner: DeliveryPartner,
    @UploadedFile() file: MulterFile,
  ) {
    if (!file) {
      throw new BadRequestException('No file. Use form field "file".');
    }
    return this.partnerService.uploadVehiclePhoto(partner.id, file, 'vehicle_photo');
  }

  @Post('upload-vehicle-document')
  @UseInterceptors(
    FileInterceptor('file', { limits: { fileSize: DOCUMENT_MAX_BYTES } }),
  )
  async uploadVehicleDocument(
    @CurrentPartner() partner: DeliveryPartner,
    @UploadedFile() file: MulterFile,
  ) {
    if (!file) {
      throw new BadRequestException('No file. Use form field "file".');
    }
    return this.partnerService.uploadVehicleDocument(partner.id, file, 'vehicle_document');
  }
  
  @Post('personal-details')
  async personalDetails(
    @CurrentPartner() partner: DeliveryPartner,
    @Body() dto: personalDetailsDto
  ){
     await this.partnerService.addPersonalDetials(partner.id,dto)
     return { success: true, message: "partner details added..." };
  }
  
  @Post('/update/profile')
  async updatePersonalDetails(
    @CurrentPartner() partner: DeliveryPartner,
    @Body() dto: updatePersonalDetailsDto
  ){
     const data = await this.partnerService.updatePersonalDetails(partner.id,dto)
     return { success: true, data, message: "partner details updated..." };
  }
  //ending of class
}



