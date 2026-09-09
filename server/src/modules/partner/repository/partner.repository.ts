import { Injectable, NotFoundException, BadRequestException, Inject } from '@nestjs/common';
import { PrismaService } from '../../../config/prisma.service';
import { DeliveryPartner } from '@prisma/client';
import { UpdateProfileDto } from '../dto/profile.dto';
import { UpdateVehicleDto } from '../dto/vehicle.dto';
import { UpdateBankDto } from '../dto/bank.dto';
import type { DocumentType } from '../types/document.types';
import { personalDetailsDto } from '../dto/personalDetails.dto';
import { togglePartnerDto } from '../dto/partnerToggle.dto';
import { updatePersonalDetailsDto } from '../dto/updatePersonalDet.dto';
import e from 'express';

@Injectable()
export class PartnerRepository {
  constructor(private readonly prisma: PrismaService) { }

  async findById(id: string): Promise<DeliveryPartner | null> {
    return this.prisma.deliveryPartner.findUnique({
      where: { id },
    });
  }

  async updateProfile(
    id: string,
    dto: UpdateProfileDto,
  ): Promise<DeliveryPartner> {
    const data: { fullName?: string; profilePhoto?: string } = {};
    if (dto.full_name !== undefined) data.fullName = dto.full_name;
    if (dto.profile_photo !== undefined) data.profilePhoto = dto.profile_photo;
    return this.prisma.deliveryPartner.update({
      where: { id },
      data,
    });
  }

  async updateVehicle(
    id: string,
    dto: UpdateVehicleDto,
  ): Promise<DeliveryPartner> {
    return this.prisma.deliveryPartner.update({
      where: { id },
      data: {
        vehicleType: dto.vehicle_type,
        vehicleNumber: dto.vehicle_number,
        vehicleBodyType: dto.vehicle_body_type,
        vehicleFuelType: dto.vehicle_fuel_type,
        vehicleRegistrationNumber: dto.vehicle_registration_number,
        vehicleBrandName: dto.vehicle_brand_name,
        manufactureIn: dto.manufacture_in,
        vehicleHeight: dto.vehicle_height,
        vehicleWeight: dto.vehicle_weight
        // aadhaarNumber: dto.aadhaar_number,
        // licenseNumber: dto.license_number,
      },
    });
  }

  async getVehicle(
    id: string,
  ) {
    return this.prisma.deliveryPartner.findUnique({
      where: { id },
      select: {
        vehicleBodyType: true,
        vehicleBrandName: true,
        vehicleDocument: true,
        vehicleFuelType: true,
        vehicleNumber: true,
        vehiclePhoto: true,
        vehicleRegistrationNumber: true,
        vehicleType: true
      }
    });
  }

  async updateBank(id: string, dto: UpdateBankDto): Promise<DeliveryPartner> {
    return this.prisma.deliveryPartner.update({
      where: { id },
      data: {
        accountNumber: dto.account_number,
        ifscCode: dto.ifsc_code,
        bankName: dto.bank_name,
        accountHolderName: dto.account_holder_name
      },
    });
  }

  async updateDocumentUrl(
    id: string,
    type: DocumentType,
    url: string,
  ): Promise<DeliveryPartner> {
    const data: Partial<Record<'aadhaarImageUrl' | 'aadhaarPdfUrl' | 'panCardUrl', string>> = {};
    if (type === 'aadhaar_image') data.aadhaarImageUrl = url;
    else if (type === 'aadhaar_pdf') data.aadhaarPdfUrl = url;
    else data.panCardUrl = url;
    return this.prisma.deliveryPartner.update({
      where: { id },
      data,
    });
  }

  async addPartnerPersonalDetails(id: string, dto: personalDetailsDto) {
    return this.prisma.deliveryPartner.update({
      where: {
        id
      },
      data: {
        fullName: dto.fullName,
        email: dto.email,
        city: dto.city,
        address: dto.address
      }
    })
  }

  async updatePartnerVehiclePhoto(id: string, url: string) {
    return this.prisma.deliveryPartner.update({
      where: {
        id
      },
      data: {
        vehiclePhoto: url
      }
    })
  }

  async updatePartnerVehicleDocument(id: string, url: string) {
    return this.prisma.deliveryPartner.update({
      where: {
        id
      },
      data: {
        vehicleDocument: url
      }
    })
  }

  async toggle(partner: string, dto: togglePartnerDto) {
    return this.prisma.deliveryPartner.update({
      where: {
        id: partner
      },
      data: {
        isOnline: dto.IsOnline
      },
      select: {
        isOnline: true
      }
    })
  }

  async updatePersonalDetails(partner: string, dto: updatePersonalDetailsDto) {
    const mobileNumber = dto.mobile_number?.toString();

    try {
      if (mobileNumber) {
        const existing = await this.prisma.deliveryPartner.findFirst({
          where: {
            mobileNumber,
          }
        });
        
        if (existing) {
          throw new BadRequestException("Mobile number already in use");
        }
        console.log(existing)
      }

      const val = await this.prisma.deliveryPartner.update({
        where: {
          id: partner
        },
        data: {
          email: dto.email,
          mobileNumber,
          address:dto.address
        },
        select:{
          email:true,
          mobileNumber:true,
          address:true
        }
      });

      return val ;

    } catch (error) {
      // 🔥 fallback safety
      if (error.code === "P2002") {
        throw new BadRequestException("Mobile number already exists");
      }
      throw error;
    }
  }
  async updateRazorpayDetails(
  partnerId: string,
  data: {
   razorpayFundAccountId: string;
  },
) {
  return this.prisma.deliveryPartner.update({
    where: { id: partnerId },
    data,
  });
}
}
