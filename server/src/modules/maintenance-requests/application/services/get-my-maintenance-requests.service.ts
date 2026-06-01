import { Injectable } from '@nestjs/common';

import { MaintenanceRequestEntity } from '../../domain/entities/maintenance-request.entity';
import { MaintenanceRequestRepository } from '../../domain/repositories/maintenance-request.repository';

@Injectable()
export class GetMyMaintenanceRequestsService {
  constructor(
    private readonly maintenanceRequestRepo: MaintenanceRequestRepository,
  ) {}

  async execute(tenantId: string): Promise<MaintenanceRequestEntity[]> {
    return this.maintenanceRequestRepo.findByTenantId(tenantId);
  }
}