import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { viewingAppointments } from 'src/shared/infrastructure/database/schema';
import {
  ViewingAppointmentEntity,
  ViewingAppointmentStatus,
} from '../domain/entities/viewing-appointment.entity';
import { ViewingAppointmentRepository } from '../domain/repositories/viewing-appointment.repository';

@Injectable()
export class DrizzleViewingAppointmentRepository
  implements ViewingAppointmentRepository
{
  constructor(private readonly drizzle: DrizzleService) {}

  private toEntity(
    row: typeof viewingAppointments.$inferSelect,
  ): ViewingAppointmentEntity {
    return new ViewingAppointmentEntity(
      row.id,
      row.tenantId,
      row.roomId,
      row.scheduledAt,
      row.status as ViewingAppointmentStatus,
      row.note,
      row.createdAt,
      row.updatedAt,
    );
  }

  async create(
    tenantId: string,
    roomId: string,
    scheduledAt: Date,
    note: string | null,
  ): Promise<ViewingAppointmentEntity> {
    const [row] = await this.drizzle.db
      .insert(viewingAppointments)
      .values({ tenantId, roomId, scheduledAt, note })
      .returning();
    return this.toEntity(row);
  }

  async findByTenantId(tenantId: string): Promise<ViewingAppointmentEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(viewingAppointments)
      .where(eq(viewingAppointments.tenantId, tenantId))
      .orderBy(viewingAppointments.scheduledAt);
    return rows.map(this.toEntity.bind(this));
  }

  async findByRoomId(roomId: string): Promise<ViewingAppointmentEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(viewingAppointments)
      .where(eq(viewingAppointments.roomId, roomId))
      .orderBy(viewingAppointments.scheduledAt);
    return rows.map(this.toEntity.bind(this));
  }

  async findById(id: string): Promise<ViewingAppointmentEntity | null> {
    const [row] = await this.drizzle.db
      .select()
      .from(viewingAppointments)
      .where(eq(viewingAppointments.id, id));
    return row ? this.toEntity(row) : null;
  }

  async updateStatus(
    id: string,
    status: ViewingAppointmentStatus,
  ): Promise<ViewingAppointmentEntity> {
    const [row] = await this.drizzle.db
      .update(viewingAppointments)
      .set({ status })
      .where(eq(viewingAppointments.id, id))
      .returning();
    return this.toEntity(row);
  }
}
