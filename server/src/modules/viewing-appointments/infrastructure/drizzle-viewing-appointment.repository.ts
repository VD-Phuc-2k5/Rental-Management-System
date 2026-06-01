import { Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import {
  properties,
  rentalRequests,
  rooms,
  viewingAppointments,
} from 'src/shared/infrastructure/database/schema';
import {
  ViewingAppointmentEntity,
  ViewingAppointmentStatus,
} from '../domain/entities/viewing-appointment.entity';
import { ViewingAppointmentRepository } from '../domain/repositories/viewing-appointment.repository';

@Injectable()
export class DrizzleViewingAppointmentRepository implements ViewingAppointmentRepository {
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
      .select({
        id: viewingAppointments.id,
        tenantId: viewingAppointments.tenantId,
        roomId: viewingAppointments.roomId,
        scheduledAt: viewingAppointments.scheduledAt,
        status: viewingAppointments.status,
        note: viewingAppointments.note,
        createdAt: viewingAppointments.createdAt,
        updatedAt: viewingAppointments.updatedAt,
        roomTitle: rooms.title,
        roomMonthlyRent: rooms.monthly_rent,
        propertyAddress: properties.address,
        propertyWard: properties.ward,
        propertyDistrict: properties.district,
        propertyCity: properties.city,
        rentalRequestId: rentalRequests.id,
      })
      .from(viewingAppointments)
      .leftJoin(rooms, eq(viewingAppointments.roomId, rooms.id))
      .leftJoin(properties, eq(rooms.propertyId, properties.id))
      .leftJoin(rentalRequests, and(
        eq(viewingAppointments.roomId, rentalRequests.roomId),
        eq(viewingAppointments.tenantId, rentalRequests.tenantId),
      ))
      .where(eq(viewingAppointments.tenantId, tenantId))
      .orderBy(viewingAppointments.scheduledAt);

    return rows.map(
      (r) =>
        new ViewingAppointmentEntity(
          r.id,
          r.tenantId,
          r.roomId,
          r.scheduledAt,
          r.status as ViewingAppointmentStatus,
          r.note,
          r.createdAt,
          r.updatedAt,
          r.roomTitle ?? undefined,
          r.propertyAddress &&
            r.propertyWard &&
            r.propertyDistrict &&
            r.propertyCity
            ? `${r.propertyAddress}, ${r.propertyWard}, ${r.propertyDistrict}, ${r.propertyCity}`
            : undefined,
          r.roomMonthlyRent ?? undefined,
          r.rentalRequestId != null,
        ),
    );
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
