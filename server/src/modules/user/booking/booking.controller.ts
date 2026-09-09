import { Controller, Post, Get, Body, Param, Req, ParseUUIDPipe } from "@nestjs/common"
import { BookingService } from "./booking.service"
import { SelectServiceDto } from "./dto/select-service.dto"
import { LocationDto } from "./dto/location.dto"
import { SelectVehicleDto } from "./dto/select-vehicle.dto"
import { ContactDetailsDto } from "./dto/contact-details.dto"
import { Request } from "express"
import { UseGuards } from "@nestjs/common"
import { AuthGuard } from "@nestjs/passport"

interface AuthRequest extends Request {
  user: {
    id: string
    mobile: string
    type: string
  }
}
@UseGuards(AuthGuard("jwt"))
@Controller("booking")
export class BookingController {

  constructor(private bookingService: BookingService) {}

  @Get("/services")
getServices() {
  return this.bookingService.getServices()
}

 @Post("session")
createSession(
  @Req() req: AuthRequest,
  @Body() dto: SelectServiceDto
) {
  const userId = req.user.id

  return this.bookingService.createSession(
    userId,
    dto.serviceType
  )
}

  @Post(":id/pickup")
  setPickup(@Param("id", new ParseUUIDPipe()) id: string, @Body() dto: LocationDto) {

    return this.bookingService.setPickup(
      id,
      dto.latitude,
      dto.longitude
    )

  }

  @Post(":id/drop")
  setDrop(@Param("id",new ParseUUIDPipe()) id: string, @Body() dto: LocationDto) {

    return this.bookingService.setDrop(
      id,
      dto.latitude,
      dto.longitude
    )

  }
  @Post(':id/contact')
@UseGuards(AuthGuard('jwt'))
async addContactDetails(
  @Req() req: any,
  @Param('id') bookingId: string,
  @Body() dto: ContactDetailsDto
) {
  return this.bookingService.addContactDetails(
    req.user.id,
    bookingId,
    dto
  );
}
   @Get(":id/vehicle-estimates")
  getVehicleEstimates(@Param("id",new ParseUUIDPipe()) id: string) {
    return this.bookingService.getVehicleEstimates(id)
  }

  @Post(":id/select-vehicle")
selectVehicle(
  @Param("id",new ParseUUIDPipe()) sessionId: string,
  @Body() dto: SelectVehicleDto
) {
  return this.bookingService.selectVehicle(sessionId, dto.vehicleId)
}

@Get(":sessionId/review")
getReview(@Param("sessionId") sessionId: string) {
  return this.bookingService.getReviewBooking(sessionId);
}

@Post(":id/confirm")
confirmBooking(@Param("id",new ParseUUIDPipe()) id: string) {
  return this.bookingService.confirmBooking(id)
}

}