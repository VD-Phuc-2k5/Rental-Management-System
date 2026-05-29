import { Injectable, NotFoundException } from '@nestjs/common';

import { UpdateMaintenanceStatusDto } from '../dto/update-maintenance-status.dto';
import { MaintenanceRequestEntity } from '../../domain/entities/maintenance-request.entity';
import { MaintenanceRequestRepository } from '../../domain/repositories/maintenance-request.repository';

@Injectable()
export class UpdateMaintenanceStatusService {
  constructor(
    private readonly maintenanceRequestRepo: MaintenanceRequestRepository,
  ) {}

  async execute(
    id: string,
    landlordId: string,
    dto: UpdateMaintenanceStatusDto,
  ): Promise<MaintenanceRequestEntity> {
    const request = await this.maintenanceRequestRepo.updateStatus(
      id,
      landlordId,
      dto.status,
    );

    if (!request) {
      throw new NotFoundException('Không tìm thấy yêu cầu sửa chữa');
    }

    return request;
  }
}