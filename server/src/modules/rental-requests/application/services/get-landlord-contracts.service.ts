import { Injectable } from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class GetLandlordContractsService {
  constructor(private readonly contractRepo: ContractRepository) {}

  async execute(landlordId: string): Promise<ContractEntity[]> {
    return this.contractRepo.findByLandlordId(landlordId);
  }
}
