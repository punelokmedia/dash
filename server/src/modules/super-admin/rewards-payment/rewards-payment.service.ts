import { PrismaService } from "@/config/prisma.service";
import { WalletService } from "@/modules/partner/wallet/wallet.service";
import { WalletTxnType } from "@prisma/client";
import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { AdminPaymentHistoryDto } from "./dto/admin-payment-history.dto";
import { Prisma } from "@prisma/client";

@Injectable()
export class RewardsPaymentService {
  constructor(
    private prisma: PrismaService,
    private walletService: WalletService,
  ) {}

  // async giveReward(
  //   driverId: string,
  //   amount: number,
  //   description: string,
  //   reason: string,
  //   adminId: string,
  // ) {
  //   return this.prisma.$transaction(async (tx) => {
  //     return this.walletService.creditWithTx(tx, driverId, null, {
  //       amount,
  //       type: "REWARD",
  //       description: description || "Incentive reward",
  //       actorType: "ADMIN",
  //       meta: {
  //         reason: reason,
  //         adminId,
  //       },
  //     });
  //   });
  // }

  // async giveAdjustment(
  //   driverId: string,
  //   amount: number,
  //   description: string,
  //   reason: string,
  //   adminId: string,
  // ) {
  //   return this.prisma.$transaction(async (tx) => {
  //     const data = await this.walletService.creditWithTx(tx, driverId, null, {
  //       amount,
  //       type: "CREDIT",
  //       description: description || "Manual adjustment",
  //       actorType: "ADMIN",
  //       meta: {
  //         reason: reason || "Customer compensation",
  //         adminId,
  //       },
  //     });

  //     console.log("data", data);

  //     return {
  //       success: true,
  //       message: `₹${amount} credited to driver's wallet as adjustment.`,
  //       data: {
  //         id: data.id,
  //         walletId: data.walletId,
  //         driverId: data.driverId,
  //         amount: data.amount,
  //         type: data.type,
  //         description: data.description,
  //         meta: data.meta,
  //         createdByType: data.createdByType,
  //         createdAt: data.createdAt,
  //       },
  //     };
  //   });
  // }

  // async applyPenalty(
  //   driverId: string,
  //   amount: number,
  //   description: string,
  //   adminId: string,
  // ) {
  //   return this.prisma.$transaction(async (tx) => {
  //     const data = await this.walletService.debitWithTx(tx, driverId, {
  //       amount,
  //       type: "PENALTY",
  //       description: description || "Late delivery penalty",
  //       actorType: "ADMIN",
  //     });
  //     console.log("data", data);

  //     return {
  //       success: true,
  //       message: `₹${amount} deducted from driver's wallet as penalty.`,
  //       data,
  //     };
  //   });
  // }

  // async adjustWallet(
  //   driverId: string,
  //   amount: number,
  //   type: "ADD" | "DEDUCT",
  //   description: string,
  //   reason: string,
  //   adminId: string,
  // ) {
  //   return this.prisma.$transaction(async (tx) => {
  //     let data;

  //     console.log("type", type);

  //     if (type === "ADD") {
  //       data = await this.walletService.creditWithTx(tx, driverId, null, {
  //         amount,
  //         type: "CREDIT",
  //         description: description || "Admin adjustment",
  //         actorType: "ADMIN",
  //         meta: {
  //           reason: reason || "",
  //           adminId: adminId,
  //         },
  //       });

  //       return {
  //         success: true,
  //         message: `₹${amount} added to driver's wallet.`,
  //         data: {
  //           id: data.id,
  //           walletId: data.walletId,
  //           driverId: data.driverId,
  //           amount: data.amount,
  //           type: data.type,
  //           description: data.description,
  //           meta: data.meta,
  //           createdByType: data.createdByType,
  //           createdAt: data.createdAt,
  //         },
  //       };
  //     }

  //     data = await this.walletService.debitWithTx(tx, driverId, {
  //       amount,
  //       type: "ADJUSTMENT",
  //       description: description || "Admin deduction",
  //       actorType: "ADMIN",
  //     });

  //     return {
  //       success: true,
  //       message: `₹${amount} deducted from driver's wallet.`,
  //       data,
  //     };
  //   });
  // }

  async rejectWithdrawal(requestId: string, reason: string) {
    return this.prisma.$transaction(async (tx) => {
      const request = await tx.withdrawalRequest.findUnique({
        where: { id: requestId },
      });

      if (!request) throw new NotFoundException("Request not found");

      if (request.status !== "PENDING") {
        throw new BadRequestException("Already processed");
      }

      if (!request.driverId) {
        throw new BadRequestException("DriverId missing in withdrawal request");
      }

      const wallet = await this.walletService.getOrCreateWallet(
        tx,
        request.driverId,
      );

      await tx.driverWallet.update({
        where: { id: wallet.id },
        data: {
          holdBalance: { decrement: request.amount },
          availableBalance: { increment: request.amount },
        },
      });

      const data = await tx.withdrawalRequest.update({
        where: { id: requestId },
        data: {
          status: "REJECTED",
          adminNote: reason,
        },
      });

      return {
        success: true,
        message:
          "Withdrawal request rejected and amount refunded to wallet successfully.",
        data: data,
      };
    });
  }

  async processWithdrawal(requestId: string, adminId: string) {
    return this.prisma.$transaction(async (tx) => {
      const request = await tx.withdrawalRequest.findUnique({
        where: { id: requestId },
      });

      if (!request) throw new NotFoundException("Request not found");

      if (request.status !== "PENDING") {
        throw new BadRequestException("Already processed");
      }

      if (!request.driverId) {
        throw new BadRequestException("DriverId missing in withdrawal request");
      }

      const wallet = await this.walletService.getOrCreateWallet(
        tx,
        request.driverId,
      );

      if (wallet.holdBalance < request.amount) {
        throw new BadRequestException("Invalid hold balance");
      }

      await tx.driverWallet.update({
        where: { id: wallet.id },
        data: {
          holdBalance: { decrement: request.amount },
        },
      });

      const data = await tx.withdrawalRequest.update({
        where: { id: requestId },
        data: {
          status: "PAID",
          processedAt: new Date(),
          adminNote: `Processed by ${adminId}`,
        },
      });

      return {
        success: true,
        message: "Withdrawal request approve successfully",
        data: data,
      };
    });
  }

  async handleTransaction(data: {
    driverId: string;
    amount: number;
    type: WalletTxnType;
    description?: string;
    reason?: string;
    adminId: string;
  }) {
    return this.prisma.$transaction(async (tx) => {
      let result;

      const creditTypes: WalletTxnType[] = ["CREDIT", "REWARD"];

      const debitTypes: WalletTxnType[] = ["DEBIT", "PENALTY", "ADJUSTMENT"];

      if (creditTypes.includes(data.type)) {
        result = await this.walletService.creditWithTx(
          tx,
          data.driverId,
          null,
          {
            amount: data.amount,
            type: data.type === "REWARD" ? "REWARD" : "CREDIT",
            description: data.description || "Admin credit",
            actorType: "ADMIN",
            meta: {
              reason: data.reason,
              adminId: data.adminId,
              type: data.type,
            },
          },
        );

        return {
          success: true,
          message: `₹${data.amount} credited to wallet (${data.type}).`,
          data: {
            id: result.id,
            walletId: result.walletId,
            driverId: result.driverId,
            amount: result.amount,
            type: result.type,
            description: result.description,
            meta: result.meta,
            createdByType: result.createdByType,
            createdAt: result.createdAt,
          },
        };
      }

      if (!debitTypes.includes(data.type)) {
        throw new BadRequestException(`Invalid transaction type: ${data.type}`);
      }

      let debitType: "DEBIT" | "PENALTY" | "ADJUSTMENT";

      if (data.type === "PENALTY") {
        debitType = "PENALTY";
      } else if (data.type === "ADJUSTMENT") {
        debitType = "ADJUSTMENT";
      } else {
        debitType = "DEBIT";
      }

      result = await this.walletService.debitWithTx(tx, data.driverId, {
        amount: data.amount,
        type: debitType,
        description: data.description || "Admin debit",
        actorType: "ADMIN",
        meta: {
          reason: data.reason,
          adminId: data.adminId,
          type: data.type,
        },
      });

      return {
        success: true,
        message: `₹${data.amount} deducted from wallet (${data.type}).`,
        data: result,
      };
    });
  }

  async getAdminPaymentHistory(query: AdminPaymentHistoryDto) {
    const page = Number(query.page) || 1;
    const limit = Number(query.limit) || 10;
    const skip = (page - 1) * limit;

    const now = new Date();
    let dateCondition: Prisma.DateTimeFilter | undefined;

    if (query.dateFilter === "THIS_MONTH") {
      dateCondition = {
        gte: new Date(now.getFullYear(), now.getMonth(), 1),
      };
    }

    if (query.dateFilter === "LAST_30_DAYS") {
      dateCondition = {
        gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
      };
    }

    if (query.dateFilter === "LAST_90_DAYS") {
      dateCondition = {
        gte: new Date(Date.now() - 90 * 24 * 60 * 60 * 1000),
      };
    }

    const where: Prisma.PaymentWhereInput = {
      ...(query.method && { method: query.method }),
      ...(query.status && { paymentStatus: query.status }),
      ...(dateCondition && { createdAt: dateCondition }),

      ...(query.minAmount || query.maxAmount
        ? {
            amount: {
              ...(query.minAmount && { gte: Number(query.minAmount) }),
              ...(query.maxAmount && { lte: Number(query.maxAmount) }),
            },
          }
        : {}),

      ...(query.search && {
        OR: [
          {
            order: {
              id: {
                contains: query.search,
              },
            },
          },
          {
            order: {
              user: {
                fullName: {
                  contains: query.search,
                  mode: "insensitive",
                },
              },
            },
          },
          {
            order: {
              driver: {
                fullName: {
                  contains: query.search,
                  mode: "insensitive",
                },
              },
            },
          },
        ],
      }),
    };

    const [payments, total] = await Promise.all([
      this.prisma.payment.findMany({
        where,
        include: {
          order: {
            select: {
              id: true,
              user: {
                select: {
                  id: true,
                  fullName: true,
                },
              },
              driver: {
                select: {
                  id: true,
                  fullName: true,
                },
              },
            },
          },
        },
        orderBy: {
          createdAt: query.sort === "asc" ? "asc" : "desc",
        },
        skip,
        take: limit,
      }),

      this.prisma.payment.count({ where }),
    ]);

    return {
      success: true,
      message: "Admin payment history fetched",
      meta: {
        total,
        page,
        limit,
        totalPages: Math.ceil(total / limit),
      },
      data: payments.map((p) => ({
        id: p.id,
        trackingId: p.order?.id || "N/A",
        clientName: p.order?.user?.fullName || "N/A",
        driverName: p.order?.driver?.fullName || "N/A",
        amount: p.amount,
        status: p.paymentStatus,
        method: p.method,
        createdAt: p.createdAt,
      })),
    };
  }

  async getTransactionDetails(paymentId: string) {
    const payment = await this.prisma.payment.findUnique({
      where: { id: paymentId },
      include: {
        order: {
          select: {
            id: true,
            user: {
              select: {
                id: true,
                fullName: true,
                mobileNumber: true,
              },
            },
            driver: {
              select: {
                id: true,
                fullName: true,
                mobileNumber: true,
              },
            },
          },
        },
        walletTransactions: {
          orderBy: { createdAt: "desc" },
        },
      },
    });

    if (!payment) {
      throw new NotFoundException("Transaction not found");
    }

    return {
      success: true,
      message: "Transaction details fetched",
      data: {
        id: payment.id,
        trackingId: payment.order?.id || "N/A",

        amount: payment.amount,
        status: payment.paymentStatus,
        method: payment.method,
        provider: payment.provider,

        createdAt: payment.createdAt,

        client: {
          id: payment.order?.user?.id,
          name: payment.order?.user?.fullName,
          mobile: payment.order?.user?.mobileNumber,
        },

        driver: {
          id: payment.order?.driver?.id,
          name: payment.order?.driver?.fullName,
          mobile: payment.order?.driver?.mobileNumber,
        },

        walletTransactions: payment.walletTransactions,
      },
    };
  }
}
