import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class FinishContractService {
  constructor(private readonly contractRepo: ContractRepository) {}

  async execute(
    contractId: string,
    landlordId: string,
  ): Promise<ContractEntity> {
    const contract = await this.contractRepo.findById(contractId);
    if (!contract) throw new NotFoundException('Contract not found');
    if (contract.landlordId !== landlordId) throw new ForbiddenException();
    if (contract.status !== 'signed')
      throw new BadRequestException('Only signed contracts can be finished');
    return this.contractRepo.updateStatus(contractId, 'finished', 'finishedAt');
  }
}
