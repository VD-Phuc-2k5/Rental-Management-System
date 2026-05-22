import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { ContractEntity } from '../../domain/entities/contract.entity';

@Injectable()
export class CancelContractService {
  constructor(private readonly contractRepo: ContractRepository) {}

  async execute(contractId: string, tenantId: string): Promise<ContractEntity> {
    const contract = await this.contractRepo.findById(contractId);
    if (!contract) throw new NotFoundException('Contract not found');
    if (contract.tenantId !== tenantId) throw new ForbiddenException();
    if (!['sent', 'signed'].includes(contract.status))
      throw new BadRequestException(
        'Only sent or signed contracts can be cancelled',
      );
    return this.contractRepo.updateStatus(
      contractId,
      'cancelled',
      'cancelledAt',
    );
  }
}
