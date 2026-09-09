import { PrismaService } from "@/config/prisma.service";
import { WithdrawDto } from "@/modules/partner/wallet/dto/withdraw-dto";
import {
  Injectable,
  BadRequestException,
  NotFoundException,
} from "@nestjs/common";

import {
  WithdrawalMethod,
  WalletTxnType,
  TransactionDirection,
  WithdrawalStatus,
} from "@prisma/client";

@Injectable()
export class UserWalletService {
  constructor(private readonly prisma: PrismaService) {}

  async getWallet(userId: string) {
    let wallet = await this.prisma.userWallet.findUnique({
      where: { userId },
    });

    if (!wallet) {
      wallet = await this.prisma.userWallet.create({
        data: { userId },
      });
    }

    return {
      success: true,
      data: wallet,
    };
  }

  async getTransactions(userId: string) {
    const wallet = await this.prisma.userWallet.findUnique({
      where: { userId },
    });

    if (!wallet) {
      return { success: true, data: [] };
    }

    const transactions = await this.prisma.walletTransaction.findMany({
      where: { walletId: wallet.id },
      orderBy: { createdAt: "desc" },
    });

    return {
      success: true,
      data: transactions,
    };
  }

  async requestUserWithdrawal(userId: string, dto: WithdrawDto) {
    return this.prisma.$transaction(async (tx) => {
      if (dto.method === "UPI" && !dto.upiId) {
        throw new BadRequestException("UPI ID required");
      }

      if (dto.method === "BANK" && !dto.accountNumber) {
        throw new BadRequestException("Bank details required");
      }

      const wallet = await tx.userWallet.findUnique({
        where: { userId },
      });

      if (!wallet || wallet.balance < dto.amount) {
        throw new BadRequestException("Insufficient balance");
      }

      await tx.userWallet.update({
        where: { userId },
        data: {
          balance: { decrement: dto.amount },
        },
      });

      await tx.walletTransaction.create({
        data: {
          walletId: wallet.id,
          amount: dto.amount,
          type: "DEBIT",
          direction: "OUT",
          description: "User withdrawal",
          createdByType: "USER",
        },
      });

      return tx.withdrawalRequest.create({
        data: {
          userId,
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
}
