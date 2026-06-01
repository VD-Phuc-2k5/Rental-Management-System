import {
  Injectable,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { RentalRequestRepository } from '../../domain/repositories/rental-request.repository';
import { RentalRequestEntity } from '../../domain/entities/rental-request.entity';

@Injectable()
export class GetRentalRequestByIdService {
  constructor(private readonly rentalRequestRepo: RentalRequestRepository) {}

  async execute(id: string, tenantId: string): Promise<RentalRequestEntity> {
    const request = await this.rentalRequestRepo.findById(id);
    if (!request) throw new NotFoundException('Rental request not found');
    if (request.tenantId !== tenantId) throw new ForbiddenException();
    return request;
  }
}
