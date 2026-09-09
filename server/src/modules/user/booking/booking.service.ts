import {
  Injectable,
  NotFoundException,
  BadRequestException,
  InternalServerErrorException
} from "@nestjs/common"

import { PrismaService } from "../../../config/prisma.service"
import axios from "axios"
import { ServiceType } from "@prisma/client"
import { ContactDetailsDto } from "./dto/contact-details.dto"
import { calculateDistanceAndTime } from "@/common/utils/distance.utils"
import { BookingGateway } from "./booking.gateway";


@Injectable()
export class BookingService {

  constructor(private prisma: PrismaService,
     private bookingGateway: BookingGateway 
  ) {}

  async getServices() {
  const services = await this.prisma.service.findMany({
    where: { isActive: true }
  })

  return {
    success: true,
    data: services
  }
}


async createSession(userId: string, serviceType: ServiceType) {
  try {

    
    const existingSession = await this.prisma.bookingSession.findFirst({
      where: {
        userId,
        status: {
          in: ["IN_PROGRESS", "SEARCHING_DRIVER"]
        }
      }
    })

    if (existingSession) {
      return {
        success: true,
        message: "Existing session found",
        data: existingSession
      }
    }

 
    const session = await this.prisma.bookingSession.create({
      data: {
        userId,
        serviceType,
        status: "IN_PROGRESS"
      }
    })

    return {
      success: true,
      message: "Booking session created successfully",
      data: session
    }

  } catch (error) {
    throw new InternalServerErrorException(
      error.message || "Failed to create booking session"
    )
  }
}

 async setPickup(sessionId: string, latitude: number, longitude: number) {
  try {

    // ✅ Validate first
    if (latitude == null || longitude == null) {
      throw new BadRequestException("Invalid pickup location");
    }

    const session = await this.prisma.bookingSession.findUnique({
      where: { id: sessionId }
    });

    if (!session) {
      throw new NotFoundException("Booking session not found");
    }

    if (session.status !== "IN_PROGRESS") {
      throw new BadRequestException("Invalid booking flow");
    }

    // 🔥 Nominatim API
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
      throw new BadRequestException("Address not found");
    }

    const address = geo.data.display_name;

    // 🔥 Extract city (Nominatim style)
    const city =
      geo.data.address?.city ||
      geo.data.address?.town ||
      geo.data.address?.village ||
      "Unknown";

    // ✅ Save to DB
    await this.prisma.bookingSession.update({
      where: { id: sessionId },
      data: {
        pickupLat: latitude,
        pickupLng: longitude,
        pickupCity: city,
        pickupAddress: address
      }
    });

    return {
      success: true,
      message: "Pickup location set successfully",
      data: {
        address,
        city
      }
    };

  } catch (error) {
    throw new InternalServerErrorException(
      error.message || "Failed to set pickup"
    );
  }
}

async setDrop(sessionId: string, latitude: number, longitude: number) {
  try {

    // ✅ Validate first
    if (latitude == null || longitude == null) {
      throw new BadRequestException("Invalid drop location");
    }

    const session = await this.prisma.bookingSession.findUnique({
      where: { id: sessionId }
    });

    if (!session) {
      throw new NotFoundException("Booking session not found");
    }

    if (session.status !== "IN_PROGRESS") {
      throw new BadRequestException("Invalid booking flow");
    }

    // 🔥 Nominatim reverse geocode
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
      throw new BadRequestException("Address not found");
    }

    const address = geo.data.display_name;

    // 🔥 Extract city
    const city =
      geo.data.address?.city ||
      geo.data.address?.town ||
      geo.data.address?.village ||
      "Unknown";

    // ✅ Save to DB
    await this.prisma.bookingSession.update({
      where: { id: sessionId },
      data: {
        dropLat: latitude,
        dropLng: longitude,
        dropCity: city,
        dropAddress: address
      }
    });

    return {
      success: true,
      message: "Drop location set successfully",
      data: {
        address,
        city
      }
    };

  } catch (error) {
    throw new InternalServerErrorException(
      error.message || "Failed to set drop"
    );
  }
}
async addContactDetails(
  userId: string,
  bookingId: string,
  dto: ContactDetailsDto
) {

  const session = await this.prisma.bookingSession.findFirst({
    where: { id: bookingId, userId }
  });

  if (!session) {
    throw new NotFoundException('Booking not found');
  }

  
  const updated = await this.prisma.bookingSession.update({
    where: { id: bookingId },
    data: {
      contactName: dto.contactName,
      contactMobile: dto.contactMobile,
      
    }
  });

 
  if (dto.saveAs) {

    
  if (!session.pickupAddress) {
    throw new BadRequestException('Pickup address missing');
  }

    await this.prisma.address.create({
      data: {
        userId,

        
        name: dto.contactName,
        phone: dto.contactMobile,

       
        address: session.pickupAddress,
        latitude: session.pickupLat,
        longitude: session.pickupLng,

      
        type: dto.saveAs
      }
    });
  }

  return updated;
}
  
async getVehicleEstimates(sessionId: string) {
  try {

    const session = await this.prisma.bookingSession.findUnique({
      where: { id: sessionId }
    });

    if (!session) {
      throw new NotFoundException("Booking session not found");
    }

    // ✅ Correct validation (ONLY THIS)
    if (
      session.pickupLat == null ||
      session.pickupLng == null ||
      session.dropLat == null ||
      session.dropLng == null
    ) {
      throw new BadRequestException("Pickup or drop location missing");
    }

    // ✅ Convert to numbers
    const pickupLat = Number(session.pickupLat);
    const pickupLng = Number(session.pickupLng);
    const dropLat = Number(session.dropLat);
    const dropLng = Number(session.dropLng);

  
    // ✅ Call distance function safely
    const result = await calculateDistanceAndTime(
      pickupLat,
      pickupLng,
      dropLat,
      dropLng
    );

   

    const distanceKm = result?.distanceKm;
    const durationMin = result?.durationMin;

    // ✅ Safety check
    if (distanceKm == null || isNaN(distanceKm)) {
      throw new Error("Invalid distance calculated");
    }

    // ✅ Save estimation
    await this.prisma.bookingSession.update({
      where: { id: sessionId },
      data: {
        estimatedDistance: distanceKm,
        estimatedDuration: durationMin
      }
    });

    // ✅ Get vehicles
    const vehicles = await this.prisma.vehicle.findMany({
      where: {
        isActive: true,
        serviceType: session.serviceType
      }
    });

    if (!vehicles.length) {
      throw new NotFoundException("No vehicles available");
    }

    // ✅ Calculate estimates
    const estimates = vehicles.map(vehicle => {

      const distanceFare = distanceKm * vehicle.perKmFare;
      const timeFare = durationMin * vehicle.perMinuteFare;

      const totalFare =
        vehicle.baseFare +
        distanceFare +
        timeFare;

      return {
        vehicleId: vehicle.id,
        name: vehicle.name,
        capacity: vehicle.capacity,
        image: vehicle.imageUrl,

        fare: {
          min: Math.round(totalFare * 0.9),
          max: Math.round(totalFare * 1.1)
        },

        etaMinutes: Math.round(durationMin),
        distanceKm: Number(distanceKm.toFixed(2))
      };

    });

    // ✅ Final response
    return {
      success: true,
      message: "Vehicle estimates fetched successfully",
      data: {
        distanceKm: Number(distanceKm.toFixed(2)),
        durationMinutes: Math.round(durationMin),
        vehicles: estimates
      }
    };

  } catch (error) {
    console.log("VEHICLE ESTIMATE ERROR:", error);

    throw new InternalServerErrorException(
      error.message || "Failed to fetch vehicle estimates"
    );
  }
}

 async selectVehicle(sessionId: string, vehicleId: string) {
  try {

    const session = await this.prisma.bookingSession.findUnique({
      where: { id: sessionId }
    })

    if (!session) {
      throw new NotFoundException("Booking session not found")
    }

    if (!session.estimatedDistance || !session.estimatedDuration) {
      throw new BadRequestException("Please fetch vehicle estimates first")
    }

    const vehicle = await this.prisma.vehicle.findUnique({
      where: { id: vehicleId }
    })

    if (!vehicle) {
      throw new NotFoundException("Vehicle not found")
    }


    const distanceKm = session.estimatedDistance
    const durationMin = session.estimatedDuration

    const totalFare =
      vehicle.baseFare +
      distanceKm * vehicle.perKmFare +
      durationMin * vehicle.perMinuteFare

    await this.prisma.bookingSession.update({
      where: { id: sessionId },
      data: {
        vehicleId: vehicle.id,
        estimatedFare: Math.round(totalFare)
      }
    })

    return {
      success: true,
      message: "Vehicle selected successfully",
      data: {
        vehicle: vehicle.name,
        estimatedFare: Math.round(totalFare)
      }
    }

  } catch (error) {
    throw new InternalServerErrorException(
      error.message || "Failed to select vehicle"
    )
  }
}

async getReviewBooking(sessionId: string) {
  try {

    const session = await this.prisma.bookingSession.findUnique({
      where: { id: sessionId }
    });

    if (!session) {
      throw new NotFoundException("Booking session not found");
    }

    if (!session.vehicleId) {
      throw new BadRequestException("Vehicle not selected");
    }

    const vehicle = await this.prisma.vehicle.findUnique({
      where: { id: session.vehicleId }
    });

    if (!vehicle) {
      throw new NotFoundException("Vehicle not found");
    }

    // ✅ Fare calculation (reuse existing)
    const distanceKm = session.estimatedDistance!;
    const durationMin = session.estimatedDuration!;

    const baseFare = vehicle.baseFare;
    const distanceFare = distanceKm * vehicle.perKmFare;
    const timeFare = durationMin * vehicle.perMinuteFare;

    const total = Math.round(baseFare + distanceFare + timeFare);

    return {
      success: true,
      message: "Review booking fetched successfully",
      data: {
        trip: {
          pickupAddress: session.pickupAddress,
          dropAddress: session.dropAddress,
          contactName: session.contactName,
          contactMobile: session.contactMobile
        },

        vehicle: {
          name: vehicle.name,
          image: vehicle.imageUrl,
          capacity: vehicle.capacity
        },

        fareBreakdown: {
          baseFare,
          distanceFare: Math.round(distanceFare),
          timeFare: Math.round(timeFare)
        },

        estimates: {
          distanceKm: Number(distanceKm.toFixed(2)),
          etaMinutes: Math.round(durationMin)
        },

        extras: [
          {
            name: "Strong Hands",
            price: 10,
            description: "Loading/unloading help"
          }
        ],

        totalAmount: total
      }
    };

  } catch (error) {
    throw new InternalServerErrorException(
      error.message || "Failed to fetch review booking"
    );
  }
}

async confirmBooking(sessionId: string) {

  // 🔥 Step 1: Run DB transaction
  const result = await this.prisma.$transaction(async (tx) => {

    const session = await tx.bookingSession.findUnique({
      where: { id: sessionId }
    });

    if (!session) {
      throw new NotFoundException("Booking session not found");
    }

    if (session.status !== "IN_PROGRESS") {
      throw new BadRequestException("Invalid booking state");
    }

    // ✅ validations
    if (
      session.pickupLat == null ||
      session.pickupLng == null ||
      session.dropLat == null ||
      session.dropLng == null
    ) {
      throw new BadRequestException("Pickup or drop location missing");
    }

    if (!session.vehicleId) {
      throw new BadRequestException("Vehicle not selected");
    }

    if (!session.contactMobile) {
      throw new BadRequestException("Contact details missing");
    }

    if (session.estimatedFare == null) {
      throw new BadRequestException("Fare not calculated");
    }

    if (
      session.estimatedDistance == null ||
      session.estimatedDuration == null
    ) {
      throw new BadRequestException("Distance/Duration not calculated");
    }

    // ✅ Create order
    const order = await tx.order.create({
      data: {
        userId: session.userId,

        pickupAddress: session.pickupAddress!,
        dropAddress: session.dropAddress!,

        pickupLat: session.pickupLat,
        pickupLng: session.pickupLng,
        dropLat: session.dropLat,
        dropLng: session.dropLng,

        vehicleId: session.vehicleId,

        fare: session.estimatedFare,
        distanceKm: session.estimatedDistance!,
        durationMin: session.estimatedDuration!,

        status: "SEARCHING_DRIVER",
        paymentStatus: "PENDING"
      }
    });

    // ✅ Update session
    await tx.bookingSession.update({
      where: { id: sessionId },
      data: {
        status: "SEARCHING_DRIVER"
      }
    });

    return {
      session,
      order
    };
  });

  // 🔥 Step 2: AFTER transaction → start driver search
  try {

    const { session, order } = result;

    const drivers = await this.bookingGateway.findNearbyDrivers(
      sessionId,
      session.pickupLat!,
      session.pickupLng!
    );

    console.log("NEARBY DRIVERS:", drivers);

    // 🔥 Step 3: Auto assign driver (basic logic)
    if (drivers.length > 0) {
      const driver = drivers[0];

      await this.prisma.order.update({
        where: { id: order.id },
        data: {
          driverId: driver.id,
          status: "DRIVER_ASSIGNED"
        }
      });

      // 🔥 Step 4: Notify frontend
      await this.bookingGateway.assignDriver(sessionId, driver);
    }

  } catch (error) {
    console.log("Driver search failed:", error);
  }

  // ✅ Final response
  return {
    success: true,
    message: "Booking confirmed. Searching driver...",
    data: result.order
  };
}
}