import { Injectable,InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/config/prisma.service';
import { CreateAddressDto } from './dto/create-address.dto';
import { UpdateAddressDto } from './dto/update-address.dto';
import { ReverseGeocodeDto } from './dto/reverse-geocode.dto';

import axios from 'axios'

@Injectable()
export class AddressService {

  constructor(private prisma: PrismaService) {}

async create(userId: string, dto: CreateAddressDto) {
  try {
    let { latitude, longitude, address } = dto;

    // 🔥 Case 1: If lat/lon present → use reverse geocode
    if (latitude != null && longitude != null) {
      const geo = await axios.get(
        "https://nominatim.openstreetmap.org/reverse",
        {
          params: {
            lat: latitude,
            lon: longitude,
            format: "json",
            addressdetails: 1
          },
          headers: {
            "User-Agent": "porter-clone-app"
          }
        }
      );

      if (!geo.data || !geo.data.display_name) {
        throw new Error("Address not found");
      }

      address = geo.data.display_name;

      // optional: override pincode from API
      dto.pincode = geo.data.address?.postcode ?? dto.pincode;
    }

    // 🔥 Case 2: If no lat/lon → require manual address
    if (!address) {
      throw new Error("Address is required");
    }

    // 🔥 Handle default
    if (dto.isDefault) {
      await this.prisma.address.updateMany({
        where: { userId },
        data: { isDefault: false }
      });
    }

    // 🔥 Save
    return await this.prisma.address.create({
      data: {
        userId,
        name: dto.name,
        phone: dto.phone,
        house: dto.house ?? null,

        address, // ✅ dynamic

        pincode: dto.pincode ?? null,
        latitude: latitude ?? null,
        longitude: longitude ?? null,

        isDefault: dto.isDefault ?? false,
        type: dto.type ?? "other"
      }
    });

  } catch (error) {
    console.log(error);

    throw new InternalServerErrorException(
      error?.message || "Failed to create address"
    );
  }
}

  async findAll(userId: string) {
    return this.prisma.address.findMany({
      where: {  userId: userId  },
      orderBy: { createdAt: 'desc' }
      
    });
  }
  

  async findOne(userId: string, id: string) {
    return this.prisma.address.findFirst({
      where: {
        id,
        userId
      }
    });
  }

  async update(userId: string, id: string, dto: UpdateAddressDto) {

  const address = await this.prisma.address.findFirst({
    where: {
      id,
      userId
    }
  })

  if (!address) {
    throw new NotFoundException("Address not found")
  }

  return this.prisma.address.update({
    where: { id },
    data: dto
  })

}

 async remove(userId: string, id: string) {

  const address = await this.prisma.address.findFirst({
    where: { id, userId }
  })

  if (!address) {
    throw new NotFoundException("Address not found")
  }

  return this.prisma.address.delete({
    where: { id }
  })

}

  async setDefault(userId: string, id: string) {

    await this.prisma.address.updateMany({
      where: { userId },
      data: { isDefault: false }
    });

    return this.prisma.address.update({
      where: { id },
      data: { isDefault: true }
    });

  }


  async reverseGeocode(dto: ReverseGeocodeDto) {
  try {
    const { latitude, longitude } = dto;

    if (latitude == null || longitude == null) {
      throw new Error("Latitude and longitude required");
    }

    const response = await axios.get(
      "https://nominatim.openstreetmap.org/reverse",
      {
        params: {
          lat: latitude,
          lon: longitude,
          format: "json",
          addressdetails: 1
        },
        headers: {
          "User-Agent": "porter-clone-app"
        }
      }
    );

    if (!response.data) {
      throw new Error("Address not found");
    }

    const result = response.data;

    return {
      error: false,
      message: "Address fetched successfully",
      data: {
        address: result.display_name,
        city: result.address?.city || result.address?.town,
        state: result.address?.state,
        pincode: result.address?.postcode,
        latitude,
        longitude
      }
    };

  } catch (error) {
    console.log(error);

    throw new InternalServerErrorException(
      error?.message || "Failed to fetch address"
    );
  }
}

}






