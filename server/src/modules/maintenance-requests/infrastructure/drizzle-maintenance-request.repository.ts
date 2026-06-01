import { Injectable } from '@nestjs/common';
import { and, desc, eq } from 'drizzle-orm';

import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { maintenanceRequests } from 'src/shared/infrastructure/database/schema';

import {
  MaintenancePriority,
  MaintenanceRequestEntity,
  MaintenanceRequestStatus,
} from '../domain/entities/maintenance-request.entity';
import {
  CreateMaintenanceRequestInput,
  MaintenanceRequestRepository,
  ScheduleMaintenanceRequestInput,
} from '../domain/repositories/maintenance-request.repository';

@Injectable()
export class DrizzleMaintenanceRequestRepository implements MaintenanceRequestRepository {
  constructor(private readonly drizzle: DrizzleService) {}

  private toEntity(
    row: typeof maintenanceRequests.$inferSelect,
  ): MaintenanceRequestEntity {
    return new MaintenanceRequestEntity(
      row.id,
      row.tenantId,
      row.landlordId ?? null,
      row.roomId ?? null,
      row.title,
      row.description,
      row.location,
      row.priority as MaintenancePriority,
      row.status as MaintenanceRequestStatus,
      (row.imageUrls as string[]) ?? [],
      (row.complaintImageUrls as string[]) ?? [],
      row.technicianName ?? null,
      row.technicianPhone ?? null,
      row.scheduledAt ?? null,
      row.landlordNote ?? null,
      row.createdAt,
      row.updatedAt,
    );
  }

  async create(
    input: CreateMaintenanceRequestInput,
  ): Promise<MaintenanceRequestEntity> {
    const [row] = await this.drizzle.db
      .insert(maintenanceRequests)
      .values({
        tenantId: input.tenantId,
        landlordId: input.landlordId,
        roomId: input.roomId,
        title: input.title,
        description: input.description,
        location: input.location,
        priority: input.priority,
        imageUrls: input.imageUrls,
      })
      .returning();

    return this.toEntity(row);
  }

  async findByTenantId(tenantId: string): Promise<MaintenanceRequestEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(maintenanceRequests)
      .where(eq(maintenanceRequests.tenantId, tenantId))
      .orderBy(desc(maintenanceRequests.createdAt));

    return rows.map(this.toEntity.bind(this));
  }

  async findByLandlordId(
    landlordId: string,
  ): Promise<MaintenanceRequestEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(maintenanceRequests)
      .where(eq(maintenanceRequests.landlordId, landlordId))
      .orderBy(desc(maintenanceRequests.createdAt));

    return rows.map(this.toEntity.bind(this));
  }

  async updateStatus(
    id: string,
    landlordId: string,
    status: MaintenanceRequestStatus,
  ): Promise<MaintenanceRequestEntity | null> {
    const [row] = await this.drizzle.db
      .update(maintenanceRequests)
      .set({ status })
      .where(
        and(
          eq(maintenanceRequests.id, id),
          eq(maintenanceRequests.landlordId, landlordId),
        ),
      )
      .returning();

    return row ? this.toEntity(row) : null;
  }

  async schedule(
    id: string,
    landlordId: string,
    input: ScheduleMaintenanceRequestInput,
  ): Promise<MaintenanceRequestEntity | null> {
    const [row] = await this.drizzle.db
      .update(maintenanceRequests)
      .set({
        technicianName: input.technicianName ?? null,
        technicianPhone: input.technicianPhone ?? null,
        scheduledAt: input.scheduledAt ?? null,
        landlordNote: input.landlordNote ?? null,
        status: 'processing',
      })
      .where(
        and(
          eq(maintenanceRequests.id, id),
          eq(maintenanceRequests.landlordId, landlordId),
        ),
      )
      .returning();

    return row ? this.toEntity(row) : null;
  }
  async findByIdAndTenantId(
    id: string,
    tenantId: string,
  ): Promise<MaintenanceRequestEntity | null> {
    const [row] = await this.drizzle.db
      .select()
      .from(maintenanceRequests)
      .where(
        and(
          eq(maintenanceRequests.id, id),
          eq(maintenanceRequests.tenantId, tenantId),
        ),
      )
      .limit(1);

    return row ? this.toEntity(row) : null;
  }

  async completeByTenantId(
    id: string,
    tenantId: string,
  ): Promise<MaintenanceRequestEntity | null> {
    const [row] = await this.drizzle.db
      .update(maintenanceRequests)
      .set({
        status: 'completed',
      })
      .where(
        and(
          eq(maintenanceRequests.id, id),
          eq(maintenanceRequests.tenantId, tenantId),
        ),
      )
      .returning();

    return row ? this.toEntity(row) : null;
  }

  async submitComplaintByTenantId(
    id: string,
    tenantId: string,
    complaintDescription: string,
    complaintImageUrls: string[] = [],
  ): Promise<MaintenanceRequestEntity | null> {
    const current = await this.findByIdAndTenantId(id, tenantId);

    if (!current) {
      return null;
    }

    const oldDescription = current.description?.trim() ?? '';
    const complaintText = complaintDescription.trim();

    const newDescription = [oldDescription, `--- Khiếu nại ---`, complaintText]
      .filter((item) => item.length > 0)
      .join('\n\n');

    const [row] = await this.drizzle.db
      .update(maintenanceRequests)
      .set({
        description: newDescription,
        complaintImageUrls,
        status: 'complaint',
        updatedAt: new Date(),
      })
      .where(
        and(
          eq(maintenanceRequests.id, id),
          eq(maintenanceRequests.tenantId, tenantId),
        ),
      )
      .returning();

    return row ? this.toEntity(row) : null;
  }
}
