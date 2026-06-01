import { Injectable, NotFoundException } from '@nestjs/common';

import { MaintenanceRequestEntity } from '../../domain/entities/maintenance-request.entity';
import { MaintenanceRequestRepository } from '../../domain/repositories/maintenance-request.repository';

@Injectable()
export class GetMaintenanceRequestDetailService {
  constructor(
    private readonly maintenanceRequestRepo: MaintenanceRequestRepository,
  ) {}

  async execute(
    id: string,
    tenantId: string,
  ): Promise<MaintenanceRequestEntity> {
    const request = await this.maintenanceRequestRepo.findByIdAndTenantId(
      id,
      tenantId,
    );

    if (!request) {
      throw new NotFoundException('Không tìm thấy yêu cầu sửa chữa');
    }

    return request;
  }
}