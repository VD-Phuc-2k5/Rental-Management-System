import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import {
  ContractRepository,
  UpdateContractData,
} from '../../domain/repositories/contract.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class UpdateContractService {
  constructor(private readonly contractRepo: ContractRepository) {}

  async execute(
    contractId: string,
    landlordId: string,
    data: UpdateContractData,
  ): Promise<ContractEntity> {
    const contract = await this.contractRepo.findById(contractId);
    if (!contract) throw new NotFoundException('Contract not found');
    if (contract.landlordId !== landlordId) throw new ForbiddenException();
    if (contract.status !== 'draft')
      throw new BadRequestException('Only draft contracts can be updated');
    return this.contractRepo.update(contractId, data);
  }
}
