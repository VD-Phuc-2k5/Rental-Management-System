import { Injectable } from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class GetMyContractsService {
  constructor(private readonly contractRepo: ContractRepository) {}

  async execute(tenantId: string): Promise<ContractEntity[]> {
    const contracts = await this.contractRepo.findByTenantId(tenantId);
    return contracts.filter((c) => c.status !== 'cancelled');
  }
}
