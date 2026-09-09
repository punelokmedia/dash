import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { PrismaService } from "@/config/prisma.service";
import { Prisma } from "@prisma/client";
import { WithdrawDto } from "./dto/withdraw-dto";

@Injectable()
export class WalletService {
  constructor(private prisma: PrismaService) {}

  async getOrCreateWallet(tx: Prisma.TransactionClient, driverId: string) {
    let wallet = await tx.driverWallet.findUnique({
      where: { driverId },
    });

    if (!wallet) {
      wallet = await tx.driverWallet.create({
        data: { driverId },
      });
    }

    if (wallet.isFrozen) {
      throw new BadRequestException("Wallet is frozen");
    }

    return wallet;
  }

  async getOrCreateWalletDirect(driverId: string) {
    const wallet = await this.prisma.$transaction((tx) => {
      return this.getOrCreateWallet(tx, driverId);
    });

    return {
      success: true,
      message: "Wallet created or fetched successfully",
      data: wallet,
    };
  }

  async creditWithTx(
    tx: Prisma.TransactionClient,
    driverId: string,
    userId: string | null,
    data: {
      amount: number;
      type?: "CREDIT" | "REWARD";
      referenceId?: string;
      description?: string;
      actorType: "USER" | "SYSTEM" | "ADMIN";
      paymentId?: string;
      meta?: any;
    },
  ) {
    if (data.amount <= 0) {
      throw new BadRequestException("Invalid amount");
    }

    if (data.referenceId) {
      const exists = await tx.walletTransaction.findFirst({
        where: {
          referenceId: data.referenceId,
          type: data.type || "CREDIT",
        },
      });

      if (exists) return exists;
    }

    const wallet = await this.getOrCreateWallet(tx, driverId);

    const updatedWallet = await tx.driverWallet.update({
      where: { id: wallet.id },
      data: {
        ...(data.type === "REWARD"
          ? { rewardBalance: { increment: data.amount } }
          : { availableBalance: { increment: data.amount } }),
      },
    });

    const transaction = await tx.walletTransaction.create({
      data: {
        walletId: wallet.id,
        driverId,
        paymentDoneById: userId,
        paymentId: data.paymentId,
        amount: data.amount,
        type: data.type || "CREDIT",
        direction: "IN",
        referenceId: data.referenceId,
        description: data.description,
        meta: data.meta,
        createdByType: data.actorType,
      },
    });

    await tx.deliveryPartner.update({
      where: { id: driverId },
      data: {
        totalEarnings: { increment: data.amount },
        todayEarnings: { increment: data.amount },
      },
    });

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const updatedEarnings = await tx.driverEarning.upsert({
      where: {
        driverId_date: {
          driverId,
          date: today,
        },
      },
      update: {
        totalOrders: { increment: 1 },
        totalEarning: { increment: data.amount },
      },
      create: {
        driverId,
        date: today,
        totalOrders: 1,
        totalEarning: data.amount,
      },
    });

    return transaction;
  }

  async debitWithTx(
    tx: Prisma.TransactionClient,
    driverId: string,
    data: {
      amount: number;
      type?: "DEBIT" | "PENALTY" | "ADJUSTMENT";
      description?: string;
      actorType: "ADMIN" | "SYSTEM" | "DRIVER";
      meta?: any;
    },
  ) {
    if (data.amount <= 0) {
      throw new BadRequestException("Invalid amount");
    }

    const wallet = await this.getOrCreateWallet(tx, driverId);

    if (wallet.availableBalance < data.amount) {
      throw new BadRequestException("Insufficient balance");
    }

    const updatedWallet = await tx.driverWallet.update({
      where: { id: wallet.id },
      data: {
        availableBalance: { decrement: data.amount },
      },
    });

    await tx.walletTransaction.create({
      data: {
        walletId: wallet.id,
        driverId,
        amount: data.amount,
        type: data.type || "DEBIT",
        direction: "OUT",
        description: data.description,
        meta: data.meta,
        createdByType: data.actorType,
      },
    });

    return updatedWallet;
  }

 async requestDriverWithdrawal(driverId: string, dto: WithdrawDto) {
  return this.prisma.$transaction(async (tx) => {
    if (dto.method === "UPI" && !dto.upiId) {
      throw new BadRequestException("UPI ID required");
    }

    if (dto.method === "BANK" && !dto.accountNumber) {
      throw new BadRequestException("Bank details required");
    }

    const wallet = await this.getOrCreateWallet(tx, driverId);

    if (wallet.availableBalance < dto.amount) {
      throw new BadRequestException("Insufficient balance");
    }

  
    await tx.driverWallet.update({
      where: { id: wallet.id },
      data: {
        availableBalance: { decrement: dto.amount },
        holdBalance: { increment: dto.amount },
      },
    });

    await tx.walletTransaction.create({
      data: {
        walletId: wallet.id,
        driverId,
        amount: dto.amount,
        type: "DEBIT",
        direction: "OUT",
        description: "Driver withdrawal",
        createdByType: "DRIVER",
      },
    });

    return tx.withdrawalRequest.create({
      data: {
        driverId,
        amount: dto.amount,
        method: dto.method,
        upiId: dto.upiId,
        accountNumber: dto.accountNumber,
        ifscCode: dto.ifscCode,
        accountHolderName: dto.accountHolderName,
        bankName: dto.bankName,
        status: "PENDING",
      },
    });
  });
}

  async getBalance(driverId: string) {
    const wallet = await this.prisma.driverWallet.findUnique({
      where: { driverId },
    });

    if (!wallet) {
      return {
        availableBalance: 0,
        holdBalance: 0,
        rewardBalance: 0,
      };
    }

    return {
      success: true,
      message: "Wallet balance fetched successfully",
      data: wallet,
    };
  }

  async getTransactions(driverId: string, query: any) {
    const {
      page = 1,
      limit = 50,
      sort = "desc",
      type,
      direction,
      dateFilter,
      startDate,
      endDate,
      minAmount,
      maxAmount,
      paymentMethod,
    } = query;

    const skip = (page - 1) * limit;
    const take = Number(limit);

    let dateQuery: any = {};
    const now = new Date();

    if (dateFilter === "THIS_MONTH") {
      dateQuery = {
        gte: new Date(now.getFullYear(), now.getMonth(), 1),
        lte: now,
      };
    }

    if (dateFilter === "LAST_30_DAYS") {
      dateQuery = {
        gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
        lte: now,
      };
    }

    if (dateFilter === "LAST_90_DAYS") {
      dateQuery = {
        gte: new Date(Date.now() - 90 * 24 * 60 * 60 * 1000),
        lte: now,
      };
    }

    if (startDate || endDate) {
      dateQuery = {
        ...(startDate && { gte: new Date(startDate) }),
        ...(endDate && { lte: new Date(endDate) }),
      };
    }

    const where: Prisma.WalletTransactionWhereInput = {
      driverId,
      ...(type && { type }),
      ...(direction && { direction }),

      ...(minAmount || maxAmount
        ? {
            amount: {
              ...(minAmount && { gte: minAmount }),
              ...(maxAmount && { lte: maxAmount }),
            },
          }
        : {}),

      ...(Object.keys(dateQuery).length && {
        createdAt: dateQuery,
      }),

      ...(paymentMethod && {
        payment: {
          method: paymentMethod,
        },
      }),
    };

    const transactions = await this.prisma.walletTransaction.findMany({
      where,
      skip,
      take,
      orderBy: {
        createdAt: sort === "asc" ? "asc" : "desc",
      },
      include: {
        payment: {
          select: {
            method: true,
          },
        },
        paymentDoneBy: {
          select: {
            fullName: true,
            profilePhoto: true,
          },
        },
      },
    });

    const grouped: Record<string, any> = {};

    for (const tx of transactions) {
      const date = new Date(tx.createdAt);

      const monthKey = date.toLocaleString("en-IN", {
        month: "long",
        year: "numeric",
      });

      if (!grouped[monthKey]) {
        grouped[monthKey] = {
          month: monthKey,
          totalAmount: 0,
          transactions: [],
        };
      }

      const signedAmount = tx.direction === "IN" ? tx.amount : -tx.amount;

      grouped[monthKey].totalAmount += signedAmount;

      grouped[monthKey].transactions.push(tx);
    }

    const result = Object.values(grouped);

    return {
      success: true,
      message: "Wallet history grouped successfully",
      data: result,
    };
  }

  async getTransactionById(id: string) {
    const tx = await this.prisma.walletTransaction.findUnique({
      where: { id },
    });

    if (!tx) {
      throw new NotFoundException("Transaction not found");
    }

    return {
      success: true,
      message: "Wallet transactions fetched successfully",
      data: tx,
    };
  }

}
