import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../config/prisma.service';
import { User } from '@prisma/client';

@Injectable()
export class UserRepository {
  constructor(private readonly prisma: PrismaService) {}

  findByMobile(mobileNumber: string): Promise<User | null> {
    const normalized = this.normalizeMobile(mobileNumber);
    return this.prisma.user.findUnique({
      where: { mobileNumber: normalized },
    });
  }

  findById(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: { id },
    });
  }

  create(mobileNumber: string): Promise<User> {
    const normalized = this.normalizeMobile(mobileNumber);
    return this.prisma.user.create({
      data: { mobileNumber: normalized },
    });
  }

  updateLastLogin(userId: string): Promise<void> {
    return this.prisma.user
      .update({
        where: { id: userId },
        data: { lastLogin: new Date() },
      })
      .then(() => undefined);
  }
 async addGstIn(userid:string,gstin:string):Promise<{ gstIn: string | null; message: string }>{
    const gstin_result = await this.prisma.user.update({
      where:{id:userid},
      data:{gstin}
    })
    return {gstIn: gstin_result.gstin, message:"gstin added successfully"}
  }

  updateProfile(
    userId: string,
    data: {
      fullName?: string;
      email?: string;
      usingFor?: string;
      addressLine1?: string;
      addressLine2?: string;
      city?: string;
      state?: string;
      pincode?: string;
      landmark?: string;
    },
  ): Promise<User> {
    const payload: Record<string, string | undefined> = {};
    if (data.fullName !== undefined) payload.fullName = data.fullName;
    if (data.email !== undefined) payload.email = data.email;
    if (data.usingFor !== undefined) payload.usingFor = data.usingFor;
    if (data.addressLine1 !== undefined) payload.addressLine1 = data.addressLine1;
    if (data.addressLine2 !== undefined) payload.addressLine2 = data.addressLine2;
    if (data.city !== undefined) payload.city = data.city;
    if (data.state !== undefined) payload.state = data.state;
    if (data.pincode !== undefined) payload.pincode = data.pincode;
    if (data.landmark !== undefined) payload.landmark = data.landmark;
    return this.prisma.user.update({
      where: { id: userId },
      data: payload,
    });
  }

  normalizeMobile(mobile: string): string {
    const digits = mobile.replace(/\D/g, '');
    return digits.length === 12 && digits.startsWith('91')
      ? digits.slice(2)
      : digits.length === 10
        ? digits
        : mobile;
  }
}
