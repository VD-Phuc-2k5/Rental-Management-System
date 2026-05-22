import { Injectable } from '@nestjs/common';
import { ViewingAppointmentRepository } from '../../domain/repositories/viewing-appointment.repository';
import { ViewingAppointmentEntity } from '../../domain/entities/viewing-appointment.entity';

@Injectable()
export class GetMyViewingAppointmentsService {
  constructor(private readonly repo: ViewingAppointmentRepository) {}

  async execute(tenantId: string): Promise<ViewingAppointmentEntity[]> {
    return this.repo.findByTenantId(tenantId);
  }
}
