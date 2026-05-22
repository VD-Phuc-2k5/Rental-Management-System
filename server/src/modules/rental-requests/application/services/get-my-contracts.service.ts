import { Injectable } from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class GetMyContractsService {
  constructor(private readonly contractRepo: ContractRepository) {}

  async execute(tenantId: string): Promise<ContractEntity[]> {
    return this.contractRepo.findByTenantId(tenantId);
  }
}
