import { Module } from "@nestjs/common"
import { BookingController } from "./booking.controller"
import { BookingService } from "./booking.service"
import { PrismaService } from "../../../config/prisma.service"
import { BookingGateway } from "./booking.gateway"

@Module({
  controllers: [BookingController],
  providers: [BookingService, PrismaService, BookingGateway],
})
export class BookingModule {}