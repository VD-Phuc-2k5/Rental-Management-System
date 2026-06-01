import { Injectable } from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class GetLandlordContractsService {
  constructor(private readonly contractRepo: ContractRepository) {}

  async execute(landlordId: string): Promise<ContractEntity[]> {
    const contracts = await this.contractRepo.findByLandlordId(landlordId);
    return contracts.filter((c) => c.status !== 'cancelled');
  }
}
