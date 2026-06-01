import {
  Injectable,
  ForbiddenException,
  NotFoundException,
} from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class GetContractDetailService {
  constructor(private readonly contractRepo: ContractRepository) {}

  async execute(contractId: string, userId: string): Promise<ContractEntity> {
    const contract = await this.contractRepo.findById(contractId);
    if (!contract) throw new NotFoundException('Contract not found');
    if (contract.tenantId !== userId && contract.landlordId !== userId)
      throw new ForbiddenException();
    return contract;
  }
}
