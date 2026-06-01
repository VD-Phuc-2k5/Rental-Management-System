import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { rooms } from 'src/shared/infrastructure/database/schema';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { RentalRequestRepository } from '../../domain/repositories/rental-request.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class SignContractService {
  constructor(
    private readonly contractRepo: ContractRepository,
    private readonly rentalRequestRepo: RentalRequestRepository,
    private readonly drizzle: DrizzleService,
  ) {}

  async execute(contractId: string, tenantId: string): Promise<ContractEntity> {
    const contract = await this.contractRepo.findById(contractId);
    if (!contract) throw new NotFoundException('Contract not found');
    if (contract.tenantId !== tenantId) throw new ForbiddenException();
    if (contract.status !== 'sent')
      throw new BadRequestException('Contract must be in sent status to sign');

    const signed = await this.contractRepo.updateStatus(
      contractId,
      'signed',
      'signedAt',
    );

    await this.drizzle.db
      .update(rooms)
      .set({ status: 'OCCUPIED' })
      .where(eq(rooms.id, contract.roomId));

    if (contract.rentalRequestId) {
      await this.rentalRequestRepo.updateStatus(
        contract.rentalRequestId,
        'contracted',
      );
    }

    return signed;
  }
}
