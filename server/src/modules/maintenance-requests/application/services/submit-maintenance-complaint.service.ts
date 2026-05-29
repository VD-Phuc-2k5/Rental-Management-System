import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';

import { SubmitMaintenanceComplaintDto } from '../dto/submit-maintenance-complaint.dto';
import { MaintenanceRequestEntity } from '../../domain/entities/maintenance-request.entity';
import { MaintenanceRequestRepository } from '../../domain/repositories/maintenance-request.repository';

@Injectable()
export class SubmitMaintenanceComplaintService {
  constructor(
    private readonly maintenanceRequestRepo: MaintenanceRequestRepository,
  ) {}

  async execute(
    id: string,
    tenantId: string,
    dto: SubmitMaintenanceComplaintDto,
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
        'Sự cố này đã được xác nhận hoàn thành trước đó',
      );
    }

    const updatedRequest =
      await this.maintenanceRequestRepo.submitComplaintByTenantId(
        id,
        tenantId,
        dto.complaintDescription,
      );

    if (!updatedRequest) {
      throw new NotFoundException('Không tìm thấy yêu cầu sửa chữa');
    }

    return updatedRequest;
  }
}