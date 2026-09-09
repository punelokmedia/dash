import { Controller, Post, Patch, Delete, Body, UploadedFile, UseInterceptors, Get } from "@nestjs/common";
import { FileInterceptor } from "@nestjs/platform-express";
import { VehicleTypesService } from "./vehicle-types.service";
import { CreateVehicalDTO } from "./dto/create-vehical.dto";
import { UpdateVehicalDTO } from "./dto/update-vehicle.dto";
import { ToggleStatusDTO } from "./dto/toggle-status.dto";
import { IdDTO } from "./dto/Id.dto";

@Controller({ path: "super-admin/vehicle-types", version: "1" })
export class VehicleTypesController {
  constructor(private readonly service: VehicleTypesService) {}

  @Post("create")
  @UseInterceptors(FileInterceptor("image"))
  create(
    @Body() body: CreateVehicalDTO,
    @UploadedFile() file?: Express.Multer.File,
  ) {
    return this.service.createVehicle(body, file as any);
  }

  @Post("get-vehical-detail")
  getVehicalDetail(@Body() body: IdDTO) {
    return this.service.getById(body.id);
  }

  @Get("get-active-vehical-details")
  getVehicalDetails() {
    return this.service.getAllActive();
  }

  @Patch("update")
  @UseInterceptors(FileInterceptor("image"))
  update(
    @Body() body: UpdateVehicalDTO & IdDTO,
    @UploadedFile() file?: Express.Multer.File,
  ) {
    const { id, ...dto } = body;
    return this.service.updateVehicle(id, dto, file as any);
  }

  @Patch("toggle-status")
  toggleStatus(@Body() body: ToggleStatusDTO) {
    return this.service.toggleStatus(body.id, body.isActive);
  }

  @Delete("delete")
  delete(@Body() body: IdDTO) {
    return this.service.deleteVehicle(body.id);
  }
}