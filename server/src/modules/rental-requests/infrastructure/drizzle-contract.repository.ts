import { Injectable } from '@nestjs/common';
import { and, eq, lt } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { contracts } from 'src/shared/infrastructure/database/schema';
import {
  ContractEntity,
  ContractStatus,
} from '../domain/entities/contract.entity';
import {
  ContractRepository,
  UpdateContractData,
} from '../domain/repositories/contract.repository';

@Injectable()
export class DrizzleContractRepository implements ContractRepository {
  constructor(private readonly drizzle: DrizzleService) {}

  private toEntity(row: typeof contracts.$inferSelect): ContractEntity {
    return new ContractEntity(
      row.id,
      row.rentalRequestId,
      row.roomId,
      row.tenantId,
      row.landlordId,
      row.startDate,
      row.endDate,
      row.monthlyRent,
      row.deposit,
      row.status as ContractStatus,
      row.terms,
      row.vnpayNumber,
      row.sentAt,
      row.signedAt,
      row.cancelledAt,
      row.finishedAt,
      row.createdAt,
      row.updatedAt,
    );
  }

  async create(
    rentalRequestId: string,
    roomId: string,
    tenantId: string,
    landlordId: string,
    startDate: string,
    endDate: string,
    monthlyRent: string,
    deposit: string,
  ): Promise<ContractEntity> {
    const [row] = await this.drizzle.db
      .insert(contracts)
      .values({
        rentalRequestId,
        roomId,
        tenantId,
        landlordId,
        startDate,
        endDate,
        monthlyRent,
        deposit,
      })
      .returning();
    return this.toEntity(row);
  }

  async findByTenantId(tenantId: string): Promise<ContractEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(contracts)
      .where(eq(contracts.tenantId, tenantId));
    return rows.map(this.toEntity.bind(this));
  }

  async findByLandlordId(landlordId: string): Promise<ContractEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(contracts)
      .where(eq(contracts.landlordId, landlordId));
    return rows.map(this.toEntity.bind(this));
  }

  async findByRentalRequestId(
    rentalRequestId: string,
  ): Promise<ContractEntity | null> {
    const [row] = await this.drizzle.db
      .select()
      .from(contracts)
      .where(eq(contracts.rentalRequestId, rentalRequestId));
    return row ? this.toEntity(row) : null;
  }

  async findById(id: string): Promise<ContractEntity | null> {
    const [row] = await this.drizzle.db
      .select()
      .from(contracts)
      .where(eq(contracts.id, id));
    return row ? this.toEntity(row) : null;
  }

  async update(id: string, data: UpdateContractData): Promise<ContractEntity> {
    const [row] = await this.drizzle.db
      .update(contracts)
      .set({ ...data, updatedAt: new Date() })
      .where(eq(contracts.id, id))
      .returning();
    return this.toEntity(row);
  }

  async updateStatus(
    id: string,
    status: ContractStatus,
    timestampField?: 'sentAt' | 'signedAt' | 'cancelledAt' | 'finishedAt',
  ): Promise<ContractEntity> {
    const setValues: Partial<typeof contracts.$inferInsert> = {
      status,
      updatedAt: new Date(),
    };
    if (timestampField === 'sentAt') setValues.sentAt = new Date();
    else if (timestampField === 'signedAt') setValues.signedAt = new Date();
    else if (timestampField === 'cancelledAt')
      setValues.cancelledAt = new Date();
    else if (timestampField === 'finishedAt') setValues.finishedAt = new Date();

    const [row] = await this.drizzle.db
      .update(contracts)
      .set(setValues)
      .where(eq(contracts.id, id))
      .returning();
    return this.toEntity(row);
  }

  async findByRoomId(roomId: string): Promise<ContractEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(contracts)
      .where(eq(contracts.roomId, roomId));
    return rows.map(this.toEntity.bind(this));
  }

  async deleteById(id: string): Promise<void> {
    await this.drizzle.db.delete(contracts).where(eq(contracts.id, id));
  }

  async findCancelledBefore(date: Date): Promise<ContractEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(contracts)
      .where(
        and(eq(contracts.status, 'cancelled'), lt(contracts.cancelledAt, date)),
      );
    return rows.map(this.toEntity.bind(this));
  }
}
