import { Injectable } from '@nestjs/common';

import { MaintenanceRequestEntity } from '../../domain/entities/maintenance-request.entity';
import { MaintenanceRequestRepository } from '../../domain/repositories/maintenance-request.repository';

@Injectable()
export class GetLandlordMaintenanceRequestsService {
  constructor(
    private readonly maintenanceRequestRepo: MaintenanceRequestRepository,
  ) {}

  async execute(landlordId: string): Promise<MaintenanceRequestEntity[]> {
    return this.maintenanceRequestRepo.findByLandlordId(landlordId);
  }
}