import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { PrismaService } from '../../../config/prisma.service';

@WebSocketGateway({
  cors: true
})
export class BookingGateway {
  @WebSocketServer()
  server: Server;

  constructor(private prisma: PrismaService) {}

  // ✅ User joins room
  @SubscribeMessage('joinBooking')
  handleJoin(
    @ConnectedSocket() client: Socket,
    @MessageBody() bookingId: string
  ) {
    client.join(bookingId);
  }

  // ✅ Driver updates location
  @SubscribeMessage('driverLocation')
  async updateDriverLocation(
    @MessageBody() data: { driverId: string; lat: number; lng: number }
  ) {
    await this.prisma.deliveryPartner.update({
      where: { id: data.driverId },
      data: {
        latitude: data.lat,
        longitude: data.lng,
        isOnline: true
      }
    });
  }

  // 🔥 Find nearby drivers
  async findNearbyDrivers(
    bookingId: string,
    pickupLat: number,
    pickupLng: number
  ) {
    const drivers = await this.prisma.$queryRaw<any>`
      SELECT *,
      (6371 * acos(
        cos(radians(${pickupLat})) *
        cos(radians(latitude)) *
        cos(radians(longitude) - radians(${pickupLng})) +
        sin(radians(${pickupLat})) *
        sin(radians(latitude))
      )) AS distance
      FROM delivery_partners
      WHERE is_active = true
      AND is_online = true
      ORDER BY distance ASC
      LIMIT 5;
    `;

    // 🔥 send to frontend
    this.server.to(bookingId).emit('nearbyDrivers', drivers);

    return drivers;
  }

  // 🚗 Assign driver
  async assignDriver(bookingId: string, driver: any) {
    this.server.to(bookingId).emit('driverAssigned', driver);
  }
}