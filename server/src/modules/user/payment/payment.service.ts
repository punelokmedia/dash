import { PrismaService } from "@/config/prisma.service";
import {
  BadRequestException,
  Inject,
  Injectable,
  Logger,
  NotFoundException,
} from "@nestjs/common";
import { PaymentRepository } from "./repository/payment.repository";
import { CreatePaymentDto } from "./dto/create-payment.dto";
import { VerifyPaymentDto } from "./dto/verify-payment.dto";
import { PaymentMethod, PaymentProvider } from "@prisma/client";
import * as crypto from "crypto";
import { WalletService } from "@/modules/partner/wallet/wallet.service";

@Injectable()
export class PaymentService {
  private readonly logger = new Logger(PaymentService.name);

  constructor(
    private readonly paymentRepository: PaymentRepository,
    private readonly prisma: PrismaService,
    private readonly wallet: WalletService,
    @Inject("RAZORPAY") private readonly razorpay: any,
  ) {}

  async createOrder(dto: CreatePaymentDto) {
    const { orderId, method } = dto;

    const order = await this.prisma.order.findUnique({
      where: { id: orderId },
    });

    if (!order) throw new NotFoundException("Order not found");

    if (order.paymentStatus === "SUCCESS") {
      throw new BadRequestException("Order already paid");
    }

    const driverEarning = order.fare;
    const platformFee = 0;

    if (method === "COD") {
      return {
        success: true,
        message: "COD Payment selected",
        data: await this.paymentRepository.upsertPayment({
          orderId: order.id,
          amount: order.fare,
          provider: PaymentProvider.COD,
          providerOrderId: `COD_${order.id}`,
          method: "COD",
          meta: {
            fare: order.fare,
            driverEarning,
            platformFee,
          },
        }),
      };
    }

    if (method === "UPI") {
      return {
        success: true,
        message: "UPI Payment selected",
        data: await this.paymentRepository.upsertPayment({
          orderId: order.id,
          amount: order.fare,
          provider: PaymentProvider.COD,
          providerOrderId: `UPI_${order.id}`,
          method: "UPI",
          meta: {
            fare: order.fare,
            driverEarning,
            platformFee,
          },
        }),
      };
    }

    //  <--------------------razorpay part-------------------->

    // const razorpayOrder = await this.razorpay.orders.create({
    //   amount: order.fare * 100,
    //   currency: "INR",
    //   receipt: order.id,
    // });

    // await this.paymentRepository.upsertPayment({
    //   orderId: order.id,
    //   amount: order.fare,
    //   provider: PaymentProvider.RAZORPAY,
    //   providerOrderId: razorpayOrder.id,
    //   meta: {
    //     fare: order.fare,
    //     driverEarning,
    //     platformFee,
    //   },
    // });

    // return {
    //   success: true,
    //   data: razorpayOrder,
    // };
  }

  async confirmPayment(
    orderId: string,
    driverId: string,
    method: "COD" | "UPI",
  ) {
    return this.prisma.$transaction(async (tx) => {
      const order = await tx.order.findUnique({
        where: { id: orderId },
      });

      if (!order) throw new NotFoundException("Order not found");

      if (order.driverId !== driverId) {
        throw new BadRequestException("Unauthorized driver");
      }

      if (order.paymentStatus === "SUCCESS") {
        return {
          success: true,
          message: "already paid",
          data: {
            id: order?.id,
            userId: order.userId,
            driverId: order.driverId,
            distanceKm: order.distanceKm,
            durationMin: order.durationMin,
            fare: order.fare,
            status: order.status,
            paymentStatus: order.paymentStatus,
            driverEarning: order.driverEarning,
            platformFee: order.platformFee,
          },
        };
      }

      const driverEarning = order.fare;
      const platformFee = 0;

      const payment = await tx.payment.upsert({
        where: { orderId },
        update: {
          method,
          meta: {
            fare: order.fare,
            driverEarning,
            platformFee,
          },
        },
        create: {
          orderId,
          amount: order.fare,
          provider: "COD",
          providerOrderId: `${method}_${orderId}`,
          method,
          paymentStatus: "PENDING",
          meta: {
            fare: order.fare,
            driverEarning,
            platformFee,
          },
        },
      });

      const updatedPayment = await tx.payment.update({
        where: { id: payment.id },
        data: {
          paymentStatus: "SUCCESS",
          providerPaymentId: `${method}_${Date.now()}`,
          signature: method === "COD" ? "COD" : undefined,
        },
      });

      const updatedOrder = await tx.order.update({
        where: { id: orderId },
        data: {
          paymentStatus: "SUCCESS",
          status: "COMPLETED",
          driverEarning,
          platformFee,
        },
      });

      const walletTx = await this.wallet.creditWithTx(
        tx,
        driverId,
        order.userId,
        {
          amount: driverEarning,
          referenceId: orderId,
          description: method === "COD" ? "COD payment" : "UPI QR payment",
          actorType: "USER",
          paymentId: payment.id,
          meta: {
            fare: order.fare,
            platformFee,
            method,
          },
        },
      );

      return {
        success: true,
        message: `${method} payment confirmed`,
        data: {
          order: {
            id: updatedOrder.id,
            status: updatedOrder.status,
            paymentStatus: updatedOrder.paymentStatus,
            fare: updatedOrder.fare,
            driverEarning: updatedOrder.driverEarning,
            platformFee: updatedOrder.platformFee,
          },
          payment: {
            id: updatedPayment.id,
            method: updatedPayment.method,
            status: updatedPayment.paymentStatus,
            amount: updatedPayment.amount,
          },
          wallet: {
            transactionId: walletTx?.id,
            amount: walletTx?.amount,
            type: walletTx?.type,
          },
        },
      };
    });
  }

  // async confirmCOD(orderId: string, driverId: string) {
  //   return this.prisma.$transaction(async (tx) => {
  //     const order = await tx.order.findUnique({
  //       where: { id: orderId },
  //     });

  //     if (!order) throw new NotFoundException("Order not found");

  //     if (order.driverId !== driverId) {
  //       throw new BadRequestException("Unauthorized driver");
  //     }

  //     if (order.paymentStatus === "SUCCESS") {
  //       return { message: "Already paid" };
  //     }

  //     const driverEarning = order.fare;
  //     const platformFee = 0;

  //     const payment = await tx.payment.upsert({
  //       where: { orderId: order.id },
  //       update: {
  //         method: "COD",
  //         meta: {
  //           fare: order.fare,
  //           driverEarning,
  //           platformFee,
  //         },
  //       },
  //       create: {
  //         orderId: order.id,
  //         amount: order.fare,
  //         provider: "COD",
  //         providerOrderId: `COD_${order.id}`,
  //         method: "COD",
  //         paymentStatus: "PENDING",
  //         meta: {
  //           fare: order.fare,
  //           driverEarning,
  //           platformFee,
  //         },
  //       },
  //     });

  //     const updatedPayment = await tx.payment.update({
  //       where: { id: payment.id },
  //       data: {
  //         paymentStatus: "SUCCESS",
  //         providerPaymentId: `COD_${Date.now()}`,
  //         signature: "COD",
  //       },
  //     });

  //     const updeatedOrder = await tx.order.update({
  //       where: { id: order.id },
  //       data: {
  //         paymentStatus: "SUCCESS",
  //         status: "COMPLETED",
  //         driverEarning,
  //         platformFee,
  //       },
  //     });

  //     const data = await this.wallet.creditWithTx(tx, driverId, order.userId, {
  //       amount: driverEarning,
  //       referenceId: order.id,
  //       description: "COD payment",
  //       actorType: "USER",
  //       paymentId: payment.id,
  //       meta: {
  //         fare: order.fare,
  //         platformFee,
  //       },
  //     });

  //     return {
  //       success: true,
  //       message: "COD payment confirmed",
  //       data: {
  //         order: {
  //           id: updeatedOrder.id,
  //           status: updeatedOrder.status,
  //           paymentStatus: updeatedOrder.paymentStatus,
  //           fare: updeatedOrder.fare,
  //           driverEarning: updeatedOrder.driverEarning,
  //           platformFee: updeatedOrder.platformFee,
  //         },

  //         payment: {
  //           id: updatedPayment.id,
  //           method: updatedPayment.method,
  //           status: updatedPayment.paymentStatus,
  //           amount: updatedPayment.amount,
  //         },

  //         wallet: {
  //           transactionId: data?.id,
  //           amount: data?.amount,
  //           type: data?.type,
  //         },
  //       },
  //     };
  //   });
  // }

  // async confirmUPI(orderId: string, driverId: string) {
  //   return this.prisma.$transaction(async (tx) => {
  //     const order = await tx.order.findUnique({
  //       where: { id: orderId },
  //     });

  //     if (!order) throw new NotFoundException("Order not found");

  //     if (order.driverId !== driverId) {
  //       throw new BadRequestException("Unauthorized driver");
  //     }

  //     if (order.paymentStatus === "SUCCESS") {
  //       return { message: "Already paid" };
  //     }

  //     const driverEarning = order.fare;
  //     const platformFee = 0;

  //     const payment = await tx.payment.upsert({
  //       where: { orderId },
  //       update: { method: "UPI" },
  //       create: {
  //         orderId,
  //         amount: order.fare,
  //         provider: "COD", // keep COD since no gateway
  //         providerOrderId: `UPI_${orderId}`,
  //         method: "UPI",
  //       },
  //     });

  //     await tx.payment.update({
  //       where: { id: payment.id },
  //       data: {
  //         paymentStatus: "SUCCESS",
  //         providerPaymentId: `UPI_${Date.now()}`,
  //       },
  //     });

  //     await tx.order.update({
  //       where: { id: orderId },
  //       data: {
  //         paymentStatus: "SUCCESS",
  //         status: "COMPLETED",
  //         driverEarning,
  //         platformFee,
  //       },
  //     });

  //     const walletTx = await this.wallet.creditWithTx(
  //       tx,
  //       driverId,
  //       order.userId,
  //       {
  //         amount: driverEarning,
  //         referenceId: orderId,
  //         description: "UPI QR payment",
  //         actorType: "USER",
  //         paymentId: payment.id,
  //       },
  //     );

  //     return {
  //       success: true,
  //       message: "UPI payment confirmed",
  //       walletTx,
  //     };
  //   });
  // }

  async verifyPayment(dto: VerifyPaymentDto) {
    const { razorpay_order_id, razorpay_payment_id, razorpay_signature } = dto;

    const secret = process.env.RAZORPAY_SECRET!;

    const generated = crypto
      .createHmac("sha256", secret)
      .update(`${razorpay_order_id}|${razorpay_payment_id}`)
      .digest("hex");

    if (generated !== razorpay_signature) {
      throw new BadRequestException("Invalid payment signature");
    }

    return {
      success: true,
      message: "Payment verified. Awaiting webhook confirmation.",
    };
  }

  async handleWebhook(body: any, signature: string) {
    const secret = process.env.RAZORPAY_WEBHOOK_SECRET!;

    const expected = crypto
      .createHmac("sha256", secret)
      .update(JSON.stringify(body))
      .digest("hex");

    if (expected !== signature) {
      throw new BadRequestException("Invalid webhook signature");
    }

    const entity = body.payload.payment?.entity;
    if (!entity) return;

    const payment = await this.paymentRepository.findByProviderOrderId(
      entity.order_id,
    );

    if (!payment || payment.paymentStatus === "SUCCESS") return;

    return this.prisma.$transaction(async (tx) => {
      const order = await tx.order.findUnique({
        where: { id: payment.orderId },
      });

      if (!order || !order.driverId) {
        throw new BadRequestException("Invalid order or driver");
      }

      if (body.event === "payment.captured") {
        const driverEarning = order.fare * 0.8;
        const platformFee = order.fare * 0.2;

        await tx.payment.update({
          where: { id: payment.id },
          data: {
            paymentStatus: "SUCCESS",
            providerPaymentId: entity.id,
            signature: "webhook",
            method: this.mapRazorpayMethod(entity.method),
          },
        });

        await tx.order.update({
          where: { id: order.id },
          data: {
            paymentStatus: "SUCCESS",
            status: "COMPLETED",
            driverEarning,
            platformFee,
          },
        });

        await this.wallet.creditWithTx(tx, order.driverId, order.userId, {
          amount: driverEarning,
          referenceId: order.id,
          description: "Online payment",
          actorType: "SYSTEM",
          paymentId: payment.id,
        });
      }

      if (body.event === "payment.failed") {
        await tx.payment.update({
          where: { id: payment.id },
          data: {
            paymentStatus: "FAILED",
            failureReason: entity.error_description,
          },
        });
      }
    });
  }

  async getPaymentStatus(orderId: string) {
    const payment = await this.paymentRepository.findByOrderId(orderId);

    if (!payment) throw new NotFoundException("Payment not found");

    return {
      success: true,
      message: "Payment status fetched successfully",
      data: {
        status: payment.paymentStatus,
      },
    };
  }

  async getPaymentDetails(orderId: string) {
    const payment = await this.paymentRepository.findByOrderId(orderId);

    if (!payment) throw new NotFoundException("Payment not found");

    return {
      success: true,
      message: "Payment details fetched successfully",
      data: payment,
    };
  }

  async getPaymentHistory(driverId: string, query: any) {
    const {
      page = 1,
      limit = 10,
      method,
      minAmount,
      maxAmount,
      dateFilter,
      sort = "desc",
    } = query;

    const skip = (page - 1) * limit;

    let dateCondition: any = {};
    const now = new Date();

    if (dateFilter === "THIS_MONTH") {
      dateCondition = {
        gte: new Date(now.getFullYear(), now.getMonth(), 1),
      };
    }

    if (dateFilter === "LAST_30_DAYS") {
      dateCondition = {
        gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
      };
    }

    if (dateFilter === "LAST_90_DAYS") {
      dateCondition = {
        gte: new Date(Date.now() - 90 * 24 * 60 * 60 * 1000),
      };
    }

    const where: any = {
      order: { driverId },
      ...(method && { method }),
      ...(minAmount || maxAmount
        ? {
            amount: {
              ...(minAmount && { gte: Number(minAmount) }),
              ...(maxAmount && { lte: Number(maxAmount) }),
            },
          }
        : {}),
      ...(dateFilter && { createdAt: dateCondition }),
    };

    const [payments, total] = await Promise.all([
      this.prisma.payment.findMany({
        where,
        include: {
          walletTransactions: {
            orderBy: { createdAt: "desc" },
            take: 1,
            select: {
              paymentDoneById: true,
              paymentDoneBy: {
                select: {
                  id: true,
                  fullName: true,
                },
              },
              referenceId: true,
              type: true,
              direction: true,
              description: true,
              meta: true,
              createdByType: true,
              createdAt: true,
            },
          },
        },
        orderBy: {
          createdAt: sort === "asc" ? "asc" : "desc",
        },
        skip,
        take: Number(limit),
      }),

      this.prisma.payment.count({ where }),
    ]);

    const formatted = this.formatPaymentHistory(payments);
    const grouped = this.groupByYearAndMonth(formatted);

    return {
      success: true,
      message: "Payment history fetched",
      meta: {
        total,
        page: Number(page),
        limit: Number(limit),
        totalPages: Math.ceil(total / limit),
      },
      data: grouped,
    };
  }

 private formatPaymentHistory(payments: any[]) {
  return payments.map((p) => {
    const txn = p.walletTransactions[0];

    const name = txn?.paymentDoneBy?.fullName || "N/A";
    const firstLetter = name.trim().charAt(0).toUpperCase();

    const rawDate = txn?.createdAt || p.createdAt;

    return {
      paymentId: p.id,
      orderId: p.orderId,

      paymentDoneById: txn?.paymentDoneById,
      paymentDoneByName: name,
      avatarLabel: `https://api.dicebear.com/5.x/initials/svg?seed=${firstLetter}`,

      amount: txn?.amount || p.amount,
      type: txn?.type,
      direction: txn?.direction,
      description: txn?.description,
      meta: txn?.meta,
      createdByType: txn?.createdByType,

      rawCreatedAt: rawDate, 

      payment: {
        method: p.method,
        status: p.paymentStatus,
      },
    };
  });
}

  private groupByYearAndMonth(data: any[]) {
  const grouped: Record<string, any> = {};

  data.forEach((txn) => {
    const date = new Date(txn.rawCreatedAt);

    const year = date.getFullYear();
    const month = date.toLocaleString("en-IN", { month: "long" });

    if (!grouped[year]) {
      grouped[year] = {
        year,
        totalAmount: 0,
        months: {},
      };
    }

    if (!grouped[year].months[month]) {
      grouped[year].months[month] = {
        month,
        totalAmount: 0,
        transactions: [],
      };
    }
    const formattedDate = date.toLocaleString("en-IN", {
      day: "2-digit",
      month: "short",
      hour: "2-digit",
      minute: "2-digit",
    });

    grouped[year].months[month].transactions.push({
      ...txn,
      createdAt: formattedDate, 
    });

    grouped[year].months[month].totalAmount += txn.amount;
    grouped[year].totalAmount += txn.amount;
  });

  return Object.values(grouped).map((yearData: any) => ({
    year: yearData.year,
    totalAmount: yearData.totalAmount,
    months: Object.values(yearData.months),
  }));
}

  private mapRazorpayMethod(method?: string): PaymentMethod | undefined {
    switch (method) {
      case "upi":
        return "UPI";
      case "card":
        return "CARD";
      case "netbanking":
        return "NETBANKING";
      case "wallet":
        return "WALLET";
      default:
        return undefined;
    }
  }
}
