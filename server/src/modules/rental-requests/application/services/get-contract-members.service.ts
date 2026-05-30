import { Injectable, NotFoundException } from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { ContractMemberRepository } from '../../domain/repositories/contract-member.repository';
import { ContractMemberEntity } from '../../domain/entities/contract-member.entity';

@Injectable()
export class GetContractMembersService {
  constructor(
    private readonly contractRepo: ContractRepository,
    private readonly contractMemberRepo: ContractMemberRepository,
  ) {}

  async execute(
    contractId: string,
    userId: string,
  ): Promise<ContractMemberEntity[]> {
    const contract = await this.contractRepo.findById(contractId);
    if (!contract) throw new NotFoundException('Contract not found');
    if (contract.tenantId !== userId && contract.landlordId !== userId) {
      throw new NotFoundException('Contract not found');
    }

    // Lấy toàn bộ danh sách thành viên trong hợp đồng
    const members = await this.contractMemberRepo.findByContractId(contractId);

    // Chỉ trả về những thành viên chưa rời đi (leftAt === null)
    return members.filter((member) => member.leftAt === null);
  }
}
