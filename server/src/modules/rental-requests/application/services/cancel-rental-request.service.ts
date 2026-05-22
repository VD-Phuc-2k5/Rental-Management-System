import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { RentalRequestRepository } from '../../domain/repositories/rental-request.repository';

@Injectable()
export class CancelRentalRequestService {
  constructor(private readonly rentalRequestRepo: RentalRequestRepository) {}

  async execute(requestId: string, tenantId: string): Promise<void> {
    const request = await this.rentalRequestRepo.findById(requestId);
    if (!request) throw new NotFoundException('Rental request not found');
    if (request.tenantId !== tenantId) throw new ForbiddenException();
    if (request.status !== 'pending')
      throw new BadRequestException('Only pending requests can be cancelled');
    await this.rentalRequestRepo.delete(requestId);
  }
}
