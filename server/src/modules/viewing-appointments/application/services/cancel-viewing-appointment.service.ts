import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { ViewingAppointmentRepository } from '../../domain/repositories/viewing-appointment.repository';
import { ViewingAppointmentEntity } from '../../domain/entities/viewing-appointment.entity';

@Injectable()
export class CancelViewingAppointmentService {
  constructor(private readonly repo: ViewingAppointmentRepository) {}

  async execute(
    appointmentId: string,
    tenantId: string,
  ): Promise<ViewingAppointmentEntity> {
    const appt = await this.repo.findById(appointmentId);
    if (!appt) throw new NotFoundException('Appointment not found');
    if (appt.tenantId !== tenantId) throw new ForbiddenException('Not your appointment');

    return this.repo.updateStatus(appointmentId, 'cancelled');
  }
}
