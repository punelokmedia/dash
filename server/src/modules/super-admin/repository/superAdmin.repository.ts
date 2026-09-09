import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../config/prisma.service';
import { GetDocumentsDto } from '../dto/GetDocumentsDto';
import { PartnerStatusDto } from '../dto/partnerStatus.dto';
import { BlockPartnerDto } from '../dto/BlockPartnerDto';

type Partner = {
    partner_id: string;
    mobile_number: string;
};
interface reqPayloadType {

}

/**
 * Partner repository – data access only (no business logic). MVC/Clean Architecture.
 */
@Injectable()
export class superAdminRepository {
    constructor(private readonly prisma: PrismaService) { }

    async getPartnerDocuments(dto: GetDocumentsDto) {
        return this.prisma.deliveryPartner.findUnique({
            where: {
                id: dto.partner_id
            },
            select: {
                vehiclePhoto: true,
                vehicleDocument: true,
                aadhaarImageUrl: true,
                aadhaarPdfUrl: true,
                panCardUrl: true,
                verifiedDocuments: true
            }
        })
    }

    async getPartnerDocumentStatus(dto: GetDocumentsDto) {
        return this.prisma.deliveryPartner.findUnique({
            where: {
                id: dto.partner_id
            },
            select: {
                verifiedDocuments: true
            }
        })
    }

    async setPartnerDocumentStatus(dto: PartnerStatusDto) {
        if (dto.status == "pending") {
            return await this.prisma.verifiedDocuments.update({
                where: {
                    partnerId: dto.partner_id
                },
                data: {
                    aadhaar: dto.aadhaar,
                    panCard: dto.panCard,
                    licence: dto.licence,
                    bank: dto.bank,
                    vehicleDocument: dto.vehicleDocument
                }
            })
        }
        const verifiedAllDocs = await this.prisma.verifiedDocuments.findUnique({
            where: {
                partnerId: dto.partner_id
            }
        })
        if (verifiedAllDocs?.aadhaar !== "pending" && verifiedAllDocs?.bank !== "pending" && verifiedAllDocs?.licence !== "pending" && verifiedAllDocs?.panCard !== "pending" && verifiedAllDocs?.vehicleDocument !== "pending") {
            return await this.prisma.deliveryPartner.update({
                where: {
                    id: dto.partner_id
                },
                data: {
                    status: dto.status
                },
                select: {
                    status: true,
                    id: true,
                    fullName: true
                }
            })
        }
        return { message: "some document verifications is pending..." }
    }

    async getPartnerStatusDetails() {
        try {
            const stats = await this.prisma.$queryRaw<
                {
                    totaldrivers: number;
                    newdrivers: number;
                    online_drivers: number;
                    offline_drivers: number;
                    blocked_drivers: number;
                }[]
            >`
            SELECT
                COUNT(*) AS totaldrivers,
    
                COUNT(*) FILTER (
                WHERE "created_at" >= date_trunc('month', CURRENT_DATE)
                ) AS newdrivers,
    
                COUNT(*) FILTER (
                WHERE "is_online" = true
                AND "status" = 'approved'
                ) AS online_drivers,

                COUNT(*) FILTER (
                WHERE "is_online" = false
                AND "status" = 'approved'
                ) AS offline_drivers,

                COUNT(*) FILTER (
                WHERE "is_active" = false
                ) AS blocked_drivers

            FROM "delivery_partners";
            `;
            return {
                totaldrivers: Number(stats[0].totaldrivers),
                newdrivers: Number(stats[0].newdrivers),
                online_drivers: Number(stats[0].online_drivers),
                offline_drivers: Number(stats[0].offline_drivers),
                blocked_drivers: Number(stats[0].blocked_drivers)
            }
        } catch (error) {
            console.log(error)
        }
    }

    async getAllPartners() {
        return await this.prisma.deliveryPartner.findMany({
            select: {
                id: true,
                profilePhoto: true,
                fullName: true,
                mobileNumber: true,
                vehicleBrandName: true,
                vehicleRegistrationNumber: true,
                address: true
            }
        })
    }
    async blockPartner(dto:BlockPartnerDto) {
        const exist = await this.prisma.deliveryPartner.findUnique({
            where: {
                id: dto.partnerId
            }
        });
        if (exist) {
            return await this.prisma.deliveryPartner.update({
                where: {
                    id: dto.partnerId
                },
                data: {
                    isActive: dto.isActive
                },
                select:{
                    fullName:true,
                    isActive:true
                }
            })
        }else{
            return {success:false,message:"partner not found..."}
        }
    }
}
