import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { rentalRequests } from 'src/shared/infrastructure/database/schema';
import {
  RentalRequestEntity,
  RentalRequestStatus,
  MemberInfo,
  VehicleInfo,
} from '../domain/entities/rental-request.entity';
import { RentalRequestRepository } from '../domain/repositories/rental-request.repository';

@Injectable()
export class DrizzleRentalRequestRepository implements RentalRequestRepository {
  constructor(private readonly drizzle: DrizzleService) {}

  private toEntity(
    row: typeof rentalRequests.$inferSelect,
  ): RentalRequestEntity {
    return new RentalRequestEntity(
      row.id,
      row.tenantId,
      row.roomId,
      row.note,
      (row.memberInfo as MemberInfo[]) ?? [],
      (row.parkingInfo as VehicleInfo[]) ?? [],
      row.status as RentalRequestStatus,
      row.createdAt,
      row.updatedAt,
    );
  }

  async create(
    tenantId: string,
    roomId: string,
    note: string | null,
    memberInfo: MemberInfo[] = [],
    parkingInfo: VehicleInfo[] = [],
  ): Promise<RentalRequestEntity> {
    const [row] = await this.drizzle.db
      .insert(rentalRequests)
      .values({ tenantId, roomId, note, memberInfo, parkingInfo })
      .returning();
    return this.toEntity(row);
  }

  async findByTenantId(tenantId: string): Promise<RentalRequestEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(rentalRequests)
      .where(eq(rentalRequests.tenantId, tenantId));
    return rows.map(this.toEntity.bind(this));
  }

  async findById(id: string): Promise<RentalRequestEntity | null> {
    const [row] = await this.drizzle.db
      .select()
      .from(rentalRequests)
      .where(eq(rentalRequests.id, id));
    return row ? this.toEntity(row) : null;
  }

  async findByRoomId(roomId: string): Promise<RentalRequestEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(rentalRequests)
      .where(eq(rentalRequests.roomId, roomId));
    return rows.map(this.toEntity.bind(this));
  }

  async updateStatus(
    id: string,
    status: RentalRequestStatus,
  ): Promise<RentalRequestEntity> {
    const [row] = await this.drizzle.db
      .update(rentalRequests)
      .set({ status })
      .where(eq(rentalRequests.id, id))
      .returning();
    return this.toEntity(row);
  }

  async delete(id: string): Promise<void> {
    await this.drizzle.db
      .delete(rentalRequests)
      .where(eq(rentalRequests.id, id));
  }
}
