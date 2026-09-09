import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { DeliveryPartner } from '@prisma/client';
import { v2 as cloudinary } from 'cloudinary';
import { Readable } from 'stream';
import type { MulterFile } from '../../types/multer';
import { UpdateBankDto } from './dto/bank.dto';
import { personalDetailsDto } from './dto/personalDetails.dto';
import { UpdateProfileDto } from './dto/profile.dto';
import { UpdateVehicleDto } from './dto/vehicle.dto';
import { PartnerRepository } from './repository/partner.repository';
import { S3UploadService } from './s3-upload.service';
import { DocumentType } from './types/document.types';
import { togglePartnerDto } from './dto/partnerToggle.dto';
import { updatePersonalDetailsDto } from './dto/updatePersonalDet.dto';

async function uploadToCloudinary(
  partnerId: string,
  folder: string,
  file: MulterFile,
  type?: DocumentType,
) {
  const imageType = type ? type : "document";
  cloudinary.config({
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
  });
  return new Promise((resolve, reject) => {
    const uploadStream = cloudinary.uploader.upload_stream(
      {
        folder: type ? folder + "/" + type : folder,
        public_id: partnerId,
      },
      (error, result) => {
        if (error) {
          return reject(error);
        }
        console.log(result?.secure_url);
        resolve(result?.secure_url);
      },
    );

    Readable.from(file.buffer).pipe(uploadStream);
  });
}

/**
 * Delivery App – delivery boy (partner). Business logic only; no HTTP.
 * Flow: Controller → Service → Repository (Clean Architecture).
 */
@Injectable()
export class PartnerService {
  constructor(
    private readonly partnerRepository: PartnerRepository,
    private readonly s3UploadService: S3UploadService,
  //  @Inject("RAZORPAY") private razorpay: any,
  ) {}

  async getProfile(partnerId: string) {
    const partner = await this.partnerRepository.findById(partnerId);
    if (!partner) throw new NotFoundException("Partner not found");
    return this.toProfileResponse(partner);
  }

  async updateProfile(partnerId: string, dto: UpdateProfileDto) {
    const hasUpdates =
      dto.full_name !== undefined || dto.profile_photo !== undefined;
    if (!hasUpdates) {
      const partner = await this.partnerRepository.findById(partnerId);
      if (!partner) throw new NotFoundException("Partner not found");
      return this.toProfileResponse(partner);
    }
    const partner = await this.partnerRepository.updateProfile(partnerId, dto);
    return this.toProfileResponse(partner);
  }

  /** Upload photo to S3 and set profile_photo (orchestration in service, not controller). */
  async uploadProfilePhoto(
    partnerId: string,
    file: MulterFile,
    type: DocumentType,
  ): Promise<{ url: string; type: DocumentType }> {
    if (process.env.NODE_ENV === "production") {
      const profilePhotoUrl = await this.s3UploadService.uploadProfilePhoto(
        partnerId,
        file,
      );
      await this.partnerRepository.updateProfile(partnerId, {
        profile_photo: profilePhotoUrl,
      });
    }
    //  this is for local dev
    const url = (await uploadToCloudinary(
      partnerId,
      "partners",
      file,
      type,
    )) as string;
    await this.partnerRepository.updateProfile(partnerId, {
      profile_photo: url,
    });
    return { url: url, type };
  }

  async updateVehicle(partnerId: string, dto: UpdateVehicleDto) {
    const partner = await this.partnerRepository.updateVehicle(partnerId, dto);
    return this.toProfileResponse(partner);
  }

  async getVehicleDetails(partnerId: string) {
    const vehicle = await this.partnerRepository.getVehicle(partnerId);
    return vehicle;
  }

  // this is for to update bank details RezorPay.
  // async updateBank(partnerId: string, dto: UpdateBankDto) {
  //   const partner = await this.partnerRepository.findById(partnerId);
  //   if (!partner) throw new NotFoundException("Partner not found");

  //   if (!dto.account_number || !dto.ifsc_code || !dto.account_holder_name) {
  //     throw new BadRequestException("Invalid bank details");
  //   }

  //   const updatedBankDetails = await this.partnerRepository.updateBank(
  //     partnerId,
  //     dto,
  //   );

  //   let fundAccountId = updatedBankDetails.razorpayFundAccountId ?? undefined;

  //   try {
  //     const customer = await this.razorpay.customers.create({
  //       name: dto.account_holder_name,
  //       contact: String(updatedBankDetails.mobileNumber),
  //     });

  //     console.log("customer", customer);

  //     const fundAccount = await this.razorpay.fundAccount.create({
  //       customer_id: customer.id,
  //       account_type: "bank_account",
  //       bank_account: {
  //         name: dto.account_holder_name,
  //         ifsc: dto.ifsc_code,
  //         account_number: dto.account_number,
  //       },
  //     });

  //     console.log("fundAccount", fundAccount);

  //     fundAccountId = fundAccount.id;
  //   } catch (error) {
  //     console.error("RAZORPAY ERROR 👉", error);

  //     throw new BadRequestException(
  //       error?.error?.description || "Razorpay error",
  //     );
  //   }

  //   if (!fundAccountId) {
  //     throw new Error("Fund account creation failed");
  //   }

  //   const updated = await this.partnerRepository.updateRazorpayDetails(
  //     partnerId,
  //     {
  //       razorpayFundAccountId: fundAccountId,
  //     },
  //   );

  //   return this.toProfileResponse(updated);
  // }

  async updateBank(partnerId: string, dto: UpdateBankDto) {
    const partner = await this.partnerRepository.findById(partnerId);
    if (!partner) throw new NotFoundException("Partner not found");

    if (!dto.account_number || !dto.ifsc_code || !dto.account_holder_name) {
      throw new BadRequestException("Invalid bank details");
    }

    const updatedBankDetails = await this.partnerRepository.updateBank(
      partnerId,
      dto,
    );

    return {
      success: true,
      message: "Bank details updated successfully",
      data: updatedBankDetails,
    };
  }
  
  /** Upload document (Aadhaar image, Aadhaar PDF, or PAN card). Max 2 MB. */
  async uploadDocument(
    partnerId: string,
    file: MulterFile,
    type: DocumentType,
  ): Promise<{ url: string; type: DocumentType }> {
    if (process.env.NODE_ENV === "production") {
      const url = await this.s3UploadService.uploadDocument(
        partnerId,
        file,
        type,
      );
      await this.partnerRepository.updateDocumentUrl(partnerId, type, url);
      return { url, type };
    }
    // this is for local dev
    const url = (await uploadToCloudinary(
      partnerId,
      "partners",
      file,
      type,
    )) as string;
    await this.partnerRepository.updateDocumentUrl(partnerId, type, url);
    return { url, type };
  }

  private toProfileResponse(partner: DeliveryPartner) {
    return {
      id: partner.id,
      mobile_number: partner.mobileNumber,
      full_name: partner.fullName,
      email:partner.email,
      profile_photo: partner.profilePhoto,
      vehicle_type: partner.vehicleType,
      vehicle_number: partner.vehicleNumber,
      vehicle_fuel_type:partner.vehicleFuelType,
      vehicle_registration_number:partner.vehicleRegistrationNumber,
      address:partner.address,
      aadhaar_number: partner.aadhaarNumber,
      aadhaar_image_url: partner.aadhaarImageUrl,
      aadhaar_pdf_url: partner.aadhaarPdfUrl,
      pan_card_url: partner.panCardUrl,
      license_number: partner.licenseNumber,
      account_number: partner.accountNumber,
      ifsc_code: partner.ifscCode,
      bank_name: partner.bankName,
      status: partner.status,
      is_active: partner.isActive,
      is_online: partner.isOnline,
      created_at: partner.createdAt,
      last_login: partner.lastLogin,
    };
  }

  async addPersonalDetials(id: string, dto: personalDetailsDto) {
    await this.partnerRepository.addPartnerPersonalDetails(id, dto);
    return { success: true, message: "partner details added..." };
  }

  async uploadVehiclePhoto(
    partnerId: string,
    file: MulterFile,
    type: DocumentType,
  ): Promise<{ url: string; type: DocumentType }> {
    if (process.env.NODE_ENV === "production") {
      const url = await this.s3UploadService.uploadDocument(
        partnerId,
        file,
        type,
      );
      await this.partnerRepository.updateDocumentUrl(partnerId, type, url);
      return { url, type };
    } else {
      const url = (await uploadToCloudinary(
        partnerId,
        "partners",
        file,
        type,
      )) as string;
      // add in db
      this.partnerRepository.updatePartnerVehiclePhoto(partnerId, url);
      return { url, type };
    }
  }

  async uploadVehicleDocument(
    partnerId: string,
    file: MulterFile,
    type: DocumentType,
  ): Promise<{ url: string; type: DocumentType }> {
    if (process.env.NODE_ENV === "production") {
      const url = await this.s3UploadService.uploadDocument(
        partnerId,
        file,
        type,
      );
      await this.partnerRepository.updateDocumentUrl(partnerId, type, url);
      return { url, type };
    } else {
      const url = (await uploadToCloudinary(
        partnerId,
        "partners",
        file,
        type,
      )) as string;
      // add in db
      this.partnerRepository.updatePartnerVehicleDocument(partnerId, url);
      return { url, type };
    }
  }

  async toglePartnerStatus(partner: string, dto: togglePartnerDto) {
    return this.partnerRepository.toggle(partner, dto);
  }
  async updatePersonalDetails(partner:string,dto:updatePersonalDetailsDto){
    return this.partnerRepository.updatePersonalDetails(partner,dto);
  }

  
}
