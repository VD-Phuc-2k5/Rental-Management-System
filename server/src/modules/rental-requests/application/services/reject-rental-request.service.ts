import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { rooms, properties } from 'src/shared/infrastructure/database/schema';
import { RentalRequestRepository } from '../../domain/repositories/rental-request.repository';
import { ContractRepository } from '../../domain/repositories/contract.repository';

@Injectable()
export class RejectRentalRequestService {
  constructor(
    private readonly rentalRequestRepo: RentalRequestRepository,
    private readonly contractRepo: ContractRepository,
    private readonly drizzle: DrizzleService,
  ) {}

  async execute(requestId: string, landlordId: string): Promise<void> {
    const request = await this.rentalRequestRepo.findById(requestId);
    if (!request) throw new NotFoundException('Rental request not found');
    if (request.status !== 'pending')
      throw new BadRequestException('Only pending requests can be rejected');

    const [room] = await this.drizzle.db
      .select({ propertyId: rooms.propertyId })
      .from(rooms)
      .where(eq(rooms.id, request.roomId));
    if (!room) throw new NotFoundException('Room not found');

    const [prop] = await this.drizzle.db
      .select({ landlorerId: properties.landlorerId })
      .from(properties)
      .where(eq(properties.id, room.propertyId));
    if (!prop || prop.landlorerId !== landlordId)
      throw new ForbiddenException();

    await this.rentalRequestRepo.updateStatus(requestId, 'rejected');

    const contract = await this.contractRepo.findByRentalRequestId(requestId);
    if (contract && ['draft', 'sent'].includes(contract.status)) {
      await this.contractRepo.updateStatus(
        contract.id,
        'cancelled',
        'cancelledAt',
      );
    }
  }
}
