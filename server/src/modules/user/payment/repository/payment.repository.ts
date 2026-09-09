import { PrismaService } from "@/config/prisma.service";
import { Injectable } from "@nestjs/common";
import {
  Payment,
  PaymentStatus,
  PaymentProvider,
  PaymentMethod,
} from "@prisma/client";

@Injectable()
export class PaymentRepository {
  constructor(private readonly prisma: PrismaService) {}

  async upsertPayment(data: {
    orderId: string;
    amount: number;
    provider: PaymentProvider;
    providerOrderId: string;
    method?: PaymentMethod;
    meta?: any;
  }): Promise<Payment> {
    return this.prisma.payment.upsert({
      where: { orderId: data.orderId },
      update: {
        providerOrderId: data.providerOrderId,
        amount: data.amount,
        method: data.method,
        meta: data.meta,
      },
      create: {
        orderId: data.orderId,
        amount: data.amount,
        provider: data.provider,
        providerOrderId: data.providerOrderId,
        paymentStatus: PaymentStatus.PENDING,
        method: data.method,
        meta: data.meta,
      },
    });
  }

  async findByOrderId(orderId: string): Promise<Payment | null> {
    return this.prisma.payment.findUnique({
      where: { orderId },
    });
  }

  async findByProviderOrderId(
    providerOrderId: string,
  ): Promise<Payment | null> {
    return this.prisma.payment.findUnique({
      where: { providerOrderId },
    });
  }

  async markPaymentSuccess(data: {
    providerOrderId: string;
    providerPaymentId: string;
    signature: string;
    method?: PaymentMethod;
  }): Promise<Payment> {
    return this.prisma.payment.update({
      where: { providerOrderId: data.providerOrderId },
      data: {
        paymentStatus: PaymentStatus.SUCCESS,
        providerPaymentId: data.providerPaymentId,
        signature: data.signature,
        method: data.method,
      },
    });
  }

  async markPaymentFailed(data: {
    providerOrderId: string;
    reason?: string;
  }): Promise<boolean> {
    const result = await this.prisma.payment.updateMany({
      where: { providerOrderId: data.providerOrderId },
      data: {
        paymentStatus: PaymentStatus.FAILED,
        failureReason: data.reason,
      },
    });

    return result.count > 0;
  }

  async getPaymentStatus(orderId: string): Promise<PaymentStatus | null> {
    const payment = await this.prisma.payment.findUnique({
      where: { orderId },
      select: { paymentStatus: true },
    });

    return payment?.paymentStatus || null;
  }

  async creditWithTx(
    tx: PrismaService,
    driverId: string,
    data: {
      amount: number;
      referenceId?: string;
      description?: string;
      actorType: "USER" | "ADMIN" | "SYSTEM" | "DRIVER";
      meta?: any;
    },
  ) {
    if (data.amount <= 0) {
      throw new Error("Invalid amount");
    }

    const wallet = await tx.driverWallet.findUnique({
      where: { driverId },
    });

    if (!wallet) {
      throw new Error("Wallet not found");
    }

    // ✅ Update wallet availableBalance 
    await tx.driverWallet.update({
      where: { driverId },
      data: {
        availableBalance : { increment: data.amount },
      },
    });

    // ✅ Update total earnings (important)
    await tx.deliveryPartner.update({
      where: { id: driverId },
      data: {
        totalEarnings: { increment: data.amount },
      },
    });

    // ✅ Create transaction record (ledger)
    await tx.walletTransaction.create({
      data: {
        walletId: wallet.id,
        amount: data.amount,
        type: "CREDIT",
        referenceId: data.referenceId,
        description: data.description,
        meta: data.meta,
        createdByType: data.actorType,
      },
    });
  }
}
