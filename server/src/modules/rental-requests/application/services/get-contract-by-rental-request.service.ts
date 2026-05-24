import {
  Injectable,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { RentalRequestRepository } from '../../domain/repositories/rental-request.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class GetContractByRentalRequestService {
  constructor(
    private readonly contractRepo: ContractRepository,
    private readonly rentalRequestRepo: RentalRequestRepository,
  ) {}

  async execute(
    rentalRequestId: string,
    landlordId: string,
  ): Promise<ContractEntity> {
    const request = await this.rentalRequestRepo.findById(rentalRequestId);
    if (!request) throw new NotFoundException('Rental request not found');
    if (request.landlordId !== landlordId) throw new ForbiddenException();

    const contract =
      await this.contractRepo.findByRentalRequestId(rentalRequestId);
    if (!contract) throw new NotFoundException('Contract not found');
    return contract;
  }
}
