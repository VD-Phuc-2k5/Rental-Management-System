import { Injectable } from '@nestjs/common';
import { RentalRequestRepository } from '../../domain/repositories/rental-request.repository';
import { RentalRequestEntity } from '../../domain/entities/rental-request.entity';

@Injectable()
export class GetMyRentalRequestsService {
  constructor(private readonly rentalRequestRepo: RentalRequestRepository) {}

  async execute(tenantId: string): Promise<RentalRequestEntity[]> {
    return this.rentalRequestRepo.findByTenantId(tenantId);
  }
}
