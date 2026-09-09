import { Injectable, NotFoundException } from '@nestjs/common';
import { UserRepository } from './repository/user.repository';
import { User } from '@prisma/client';


export interface UserProfileResponse {
  id: string;
  mobile_number: string;
  full_name: string | null;
  profile_photo: string | null;
  email: string | null;
  using_for: string | null;
  address_line1: string | null;
  address_line2: string | null;
  city: string | null;
  state: string | null;
  pincode: string | null;
  landmark: string | null;
  role: string;
  is_active: boolean;
  created_at: Date;
  last_login: Date | null;
}

@Injectable()
export class UserService {
  constructor(private readonly userRepository: UserRepository) {}

  async getProfile(userId: string): Promise<UserProfileResponse> {
    const user = await this.userRepository.findById(userId);
    if (!user) throw new NotFoundException('User not found');
    return this.toProfileResponse(user);
  }

  async updateProfile(
    userId: string,
    data: {
      full_name?: string;
      email?: string;
      using_for?: string;
      address_line1?: string;
      address_line2?: string;
      city?: string;
      state?: string;
      pincode?: string;
      landmark?: string;
    },
  ): Promise<UserProfileResponse> {
    const user = await this.userRepository.findById(userId);
    if (!user) throw new NotFoundException('User not found');
    const updated = await this.userRepository.updateProfile(userId, {
      fullName: data.full_name,
      email: data.email,
      usingFor: data.using_for,
      addressLine1: data.address_line1,
      addressLine2: data.address_line2,
      city: data.city,
      state: data.state,
      pincode: data.pincode,
      landmark: data.landmark,
    });
    return this.toProfileResponse(updated);
  }

  private toProfileResponse(u: User): UserProfileResponse {
    return {
      id: u.id,
      mobile_number: u.mobileNumber,
      full_name: u.fullName,
      profile_photo: u.profilePhoto,
      email: u.email,
      using_for: u.usingFor,
      address_line1: u.addressLine1,
      address_line2: u.addressLine2,
      city: u.city,
      state: u.state,
      pincode: u.pincode,
      landmark: u.landmark,
      role: u.role,
      is_active: u.isActive,
      created_at: u.createdAt,
      last_login: u.lastLogin,
    };
  }

  async addGstin(userid:string,gstin:string){
    try {
      const gstin_result = await this.userRepository.addGstIn(userid,gstin);
      return gstin_result;
    } catch (error) {
      console.log(error);
    }
  }
}
  





