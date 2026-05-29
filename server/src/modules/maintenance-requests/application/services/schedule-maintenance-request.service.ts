import { Injectable, NotFoundException } from '@nestjs/common';

import { ScheduleMaintenanceRequestDto } from '../dto/schedule-maintenance-request.dto';
import { MaintenanceRequestEntity } from '../../domain/entities/maintenance-request.entity';
import { MaintenanceRequestRepository } from '../../domain/repositories/maintenance-request.repository';

@Injectable()
export class ScheduleMaintenanceRequestService {
  constructor(
    private readonly maintenanceRequestRepo: MaintenanceRequestRepository,
  ) {}

  async execute(
    id: string,
    landlordId: string,
    dto: ScheduleMaintenanceRequestDto,
  ): Promise<MaintenanceRequestEntity> {
    const request = await this.maintenanceRequestRepo.schedule(id, landlordId, {
      technicianName: dto.technicianName ?? null,
      technicianPhone: dto.technicianPhone ?? null,
      scheduledAt: dto.scheduledAt ? new Date(dto.scheduledAt) : null,
      landlordNote: dto.landlordNote ?? null,
    });

    if (!request) {
      throw new NotFoundException('Không tìm thấy yêu cầu sửa chữa');
    }

    return request;
  }
}