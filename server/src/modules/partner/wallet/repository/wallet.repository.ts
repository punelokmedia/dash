import { Injectable } from "@nestjs/common";
import { PrismaService } from "@/config/prisma.service";

@Injectable()
export class WalletRepository {
  constructor(private prisma: PrismaService) {}

  async getWallet(driverId: string) {
    return this.prisma.driverWallet.findUnique({
      where: { driverId },
    });
  }

  async createWallet(driverId: string) {
    return this.prisma.driverWallet.create({
      data: { driverId },
    });
  }

  async credit(data: {
    driverId: string;
    amount: number;
    type: "CREDIT" | "REWARD";
    referenceId?: string;
    description?: string;
    createdByType: "SYSTEM" | "ADMIN" | "USER";
  }) {
    return this.prisma.$transaction(async (tx) => {
      const wallet = await tx.driverWallet.upsert({
        where: { driverId: data.driverId },
        update: {
          availableBalance:
            data.type === "CREDIT" ? { increment: data.amount } : undefined,
          rewardBalance:
            data.type === "REWARD" ? { increment: data.amount } : undefined,
        },
        create: {
          driverId: data.driverId,
          availableBalance: data.type === "CREDIT" ? data.amount : 0,
          rewardBalance: data.type === "REWARD" ? data.amount : 0,
        },
      });

      await tx.walletTransaction.create({
        data: {
          walletId: wallet.id,
          driverId: data.driverId,
          amount: data.amount,
          type: data.type,
          referenceId: data.referenceId,
          description: data.description,
          createdByType: data.createdByType,
        },
      });

      return wallet;
    });
  }

  async debit(data: {
    driverId: string;
    amount: number;
    type: "DEBIT" | "PENALTY" | "ADJUSTMENT";
    description?: string;
    createdByType: "DRIVER" | "ADMIN" | "SYSTEM";
  }) {
    return this.prisma.$transaction(async (tx) => {
      const wallet = await tx.driverWallet.findUnique({
        where: { driverId: data.driverId },
      });

      if (!wallet) throw new Error("Wallet not found");
      if (wallet.availableBalance < data.amount) {
        throw new Error("Insufficient balance");
      }

      const updated = await tx.driverWallet.update({
        where: { driverId: data.driverId },
        data: {
          availableBalance: { decrement: data.amount },
        },
      });

      await tx.walletTransaction.create({
        data: {
          walletId: updated.id,
          driverId: data.driverId,
          amount: data.amount,
          type: data.type,
          description: data.description,
          createdByType: data.createdByType,
        },
      });

      return updated;
    });
  }

  async getTransactions(driverId: string) {
    return this.prisma.walletTransaction.findMany({
      where: { driverId },
      orderBy: { createdAt: "desc" },
    });
  }

  async getTransaction(id: string) {
    return this.prisma.walletTransaction.findUnique({
      where: { id },
    });
  }

async createWithdrawalRequest(data: {
  driverId?: string;
  userId?: string;
  amount: number;
  method: "UPI" | "BANK";
  upiId?: string;
  accountNumber?: string;
  ifscCode?: string;
  accountHolderName?: string;
  bankName?: string;
}) {
  // ❗ Validation (VERY IMPORTANT)
  if (!data.driverId && !data.userId) {
    throw new Error("Either driverId or userId is required");
  }

  if (data.driverId && data.userId) {
    throw new Error("Only one of driverId or userId should be provided");
  }

  return this.prisma.withdrawalRequest.create({
    data: {
      driverId: data.driverId ?? null,
      userId: data.userId ?? null,
      amount: data.amount,
      method: data.method,
      upiId: data.upiId,
      accountNumber: data.accountNumber,
      ifscCode: data.ifscCode,
      accountHolderName: data.accountHolderName,
      bankName: data.bankName,
    },
  });
}

  async addDriverEarning(data: {
    driverId: string;
    amount: number;
    orderId: string;
  }) {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    return this.prisma.$transaction(async (tx) => {
      // ✅ Prevent duplicate earning
      const exists = await tx.walletTransaction.findFirst({
        where: {
          referenceId: data.orderId,
          type: "CREDIT",
        },
      });

      if (exists) return;

      // 1. Update earnings
      await tx.deliveryPartner.update({
        where: { id: data.driverId },
        data: {
          totalEarnings: { increment: data.amount },
          todayEarnings: { increment: data.amount },
        },
      });

      // 2. Daily earnings
      await tx.driverEarning.upsert({
        where: {
          driverId_date: {
            driverId: data.driverId,
            date: today,
          },
        },
        update: {
          totalOrders: { increment: 1 },
          totalEarning: { increment: data.amount },
        },
        create: {
          driverId: data.driverId,
          date: today,
          totalOrders: 1,
          totalEarning: data.amount,
        },
      });

      // 3. Ensure wallet exists
      const wallet = await tx.driverWallet.upsert({
        where: { driverId: data.driverId },
        update: {},
        create: { driverId: data.driverId },
      });

      // 4. Store transaction (NO balance update)
      await tx.walletTransaction.create({
        data: {
          walletId: wallet.id,
          driverId: data.driverId,
          amount: data.amount,
          type: "CREDIT",
          referenceId: data.orderId,
          description: "Order earning",
          createdByType: "SYSTEM",
        },
      });
    });
  }
}
