import { Injectable } from '@nestjs/common';
import { desc, eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import {
  rooms,
  properties,
  rentalRequests,
} from 'src/shared/infrastructure/database/schema';
import {
  RentalRequestEntity,
  RentalRequestStatus,
  MemberInfo,
  VehicleInfo,
} from '../../domain/entities/rental-request.entity';

@Injectable()
export class GetIncomingRequestsService {
  constructor(private readonly drizzle: DrizzleService) {}

  async execute(landlordId: string): Promise<RentalRequestEntity[]> {
    const rows = await this.drizzle.db
      .select({
        id: rentalRequests.id,
        tenantId: rentalRequests.tenantId,
        roomId: rentalRequests.roomId,
        landlordId: rentalRequests.landlordId,
        note: rentalRequests.note,
        memberInfo: rentalRequests.memberInfo,
        parkingInfo: rentalRequests.parkingInfo,
        status: rentalRequests.status,
        createdAt: rentalRequests.createdAt,
        updatedAt: rentalRequests.updatedAt,
        roomTitle: rooms.title,
      })
      .from(rentalRequests)
      .innerJoin(rooms, eq(rentalRequests.roomId, rooms.id))
      .innerJoin(properties, eq(rooms.propertyId, properties.id))
      .where(eq(properties.landlorerId, landlordId))
      .orderBy(desc(rentalRequests.createdAt));

    return rows.map(
      (row) =>
        new RentalRequestEntity(
          row.id,
          row.tenantId,
          row.roomId,
          row.landlordId ?? null,
          row.note,
          (row.memberInfo as MemberInfo[]) ?? [],
          (row.parkingInfo as VehicleInfo[]) ?? [],
          row.status as RentalRequestStatus,
          row.createdAt,
          row.updatedAt,
          row.roomTitle,
        ),
    );
  }
}
