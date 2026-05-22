import { Injectable, NotFoundException } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { rooms } from 'src/shared/infrastructure/database/schema';
import { ViewingAppointmentRepository } from '../../domain/repositories/viewing-appointment.repository';
import { ViewingAppointmentEntity } from '../../domain/entities/viewing-appointment.entity';

@Injectable()
export class CreateViewingAppointmentService {
  constructor(
    private readonly repo: ViewingAppointmentRepository,
    private readonly drizzle: DrizzleService,
  ) {}

  async execute(
    tenantId: string,
    roomId: string,
    scheduledAt: Date,
    note: string | null,
  ): Promise<ViewingAppointmentEntity> {
    const [room] = await this.drizzle.db
      .select({ id: rooms.id })
      .from(rooms)
      .where(eq(rooms.id, roomId));

    if (!room) throw new NotFoundException('Room not found');

    return this.repo.create(tenantId, roomId, scheduledAt, note);
  }
}
