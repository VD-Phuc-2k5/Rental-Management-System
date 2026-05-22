import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { rooms, properties } from 'src/shared/infrastructure/database/schema';
import { ViewingAppointmentRepository } from '../../domain/repositories/viewing-appointment.repository';
import { ViewingAppointmentEntity } from '../../domain/entities/viewing-appointment.entity';

@Injectable()
export class RejectViewingAppointmentService {
  constructor(
    private readonly repo: ViewingAppointmentRepository,
    private readonly drizzle: DrizzleService,
  ) {}

  async execute(
    appointmentId: string,
    landlordId: string,
  ): Promise<ViewingAppointmentEntity> {
    const appt = await this.repo.findById(appointmentId);
    if (!appt) throw new NotFoundException('Appointment not found');

    const [prop] = await this.drizzle.db
      .select({ landlorerId: properties.landlorerId })
      .from(rooms)
      .innerJoin(properties, eq(rooms.propertyId, properties.id))
      .where(eq(rooms.id, appt.roomId));

    if (!prop || prop.landlorerId !== landlordId) {
      throw new ForbiddenException('Not your room');
    }

    return this.repo.updateStatus(appointmentId, 'rejected');
  }
}
