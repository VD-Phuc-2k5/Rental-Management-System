import { BadRequestException } from '@nestjs/common';
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
    const now = new Date();
    if (new Date(scheduledAt) < now) {
      throw new BadRequestException(
        'Thời gian xem phòng không thể nằm trong quá khứ!',
      );
    }
    const [room] = await this.drizzle.db
      .select({ id: rooms.id })
      .from(rooms)
      .where(eq(rooms.id, roomId));

    if (!room) throw new NotFoundException('Room not found');

    return this.repo.create(tenantId, roomId, scheduledAt, note);
  }
}
