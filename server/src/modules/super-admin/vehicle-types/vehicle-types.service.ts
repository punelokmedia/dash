import { Injectable, NotFoundException, BadRequestException } from "@nestjs/common";
import { VehicleTypesRepository } from "./repository/vehicle-types.repository";
import { CloudinaryService } from "@/config/cloudinary/cloudinary.service";
import { MulterFile } from "@/types/multer";
import { CreateVehicalDTO } from "./dto/create-vehical.dto";
import { UpdateVehicalDTO } from "./dto/update-vehicle.dto";

@Injectable()
export class VehicleTypesService {
  constructor(
    private readonly repo: VehicleTypesRepository,
    private readonly cloudinary: CloudinaryService,
  ) {}

  async createVehicle(dto: CreateVehicalDTO, file?: MulterFile) {
    let imageUrl: string | undefined;

    if (file) {
      imageUrl = await this.cloudinary.uploadFile(
        file,
        "vehicle-types",
        `vehicle-${Date.now()}`,
      );
    }

    const data = await this.repo.create({
      ...dto,
      imageUrl,
    });

    return {
      success: true,
      message: "Vehicle type created successfully",
      data,
    };
  }

  async getAllActive() {
    const data = await this.repo.findAllActive();

    return {
      success: true,
      message: "All vehicle types fetched successfully",
      data,
    };
  }

  async getById(id: string) {
    const vehicle = await this.repo.findById(id);

    if (!vehicle) {
      throw new NotFoundException("Vehicle type not found");
    }

    return {
      success: true,
      message: "Vehicle type fetched successfully",
      data: vehicle,
    };
  }

  async updateVehicle(id: string, dto: UpdateVehicalDTO, file?: MulterFile) {
    await this.getById(id);

    if (!dto || Object.keys(dto).length === 0) {
      throw new BadRequestException("No fields provided to update");
    }

    let imageUrl: string | undefined;

    if (file) {
      imageUrl = await this.cloudinary.uploadFile(
        file,
        "vehicle-types",
        `vehicle-${id}`,
      );
    }

    const data = await this.repo.update(id, {
      ...dto,
      ...(imageUrl && { imageUrl }),
    });

    return {
      success: true,
      message: "Vehicle type updated successfully",
      data,
    };
  }

  async toggleStatus(id: string, isActive: boolean) {
    await this.getById(id);

    const data = await this.repo.toggleStatus(id, isActive);

    return {
      success: true,
      message: `Vehicle type ${isActive ? "activated" : "deactivated"} successfully`,
      data,
    };
  }

  async deleteVehicle(id: string) {
    await this.getById(id);

    await this.repo.delete(id);

    return {
      success: true,
      message: "Vehicle type deleted successfully",
    };
  }
}
