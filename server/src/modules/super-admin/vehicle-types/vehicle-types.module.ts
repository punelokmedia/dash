import { Module } from '@nestjs/common';
import { VehicleTypesService } from './vehicle-types.service';
import { VehicleTypesController } from './vehicle-types.controller';
import { VehicleTypesRepository } from './repository/vehicle-types.repository';
import { PrismaService } from '@/config/prisma.service';
import { CloudinaryModule } from '@/config/cloudinary/cloudinary.module';

@Module({
  imports: [CloudinaryModule],
  controllers: [VehicleTypesController],
  providers: [VehicleTypesService, VehicleTypesRepository, PrismaService],
  exports:[VehicleTypesService],
})
export class VehicleTypesModule {}