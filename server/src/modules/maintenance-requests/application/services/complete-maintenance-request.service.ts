import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';

import { MaintenanceRequestEntity } from '../../domain/entities/maintenance-request.entity';
import { MaintenanceRequestRepository } from '../../domain/repositories/maintenance-request.repository';

@Injectable()
export class CompleteMaintenanceRequestService {
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

    if (request.status === 'completed') {
      throw new BadRequestException(
        'Sự cố này đã được xác nhận hoàn thành',
      );
    }

    const updatedRequest =
      await this.maintenanceRequestRepo.completeByTenantId(id, tenantId);

    if (!updatedRequest) {
      throw new NotFoundException('Không tìm thấy yêu cầu sửa chữa');
    }

    return updatedRequest;
  }
}