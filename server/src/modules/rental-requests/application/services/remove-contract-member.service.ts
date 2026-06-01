import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { ContractMemberRepository } from '../../domain/repositories/contract-member.repository';

@Injectable()
export class RemoveContractMemberService {
  constructor(
    private readonly contractRepo: ContractRepository,
    private readonly contractMemberRepo: ContractMemberRepository,
  ) {}

  async execute(
    contractId: string,
    memberId: string,
    requesterId: string,
  ): Promise<void> {
    const contract = await this.contractRepo.findById(contractId);
    if (!contract) throw new NotFoundException('Contract not found');

    const members = await this.contractMemberRepo.findByContractId(contractId);
    const requesterIsLeader = members.some(
      (m) => m.isRoomLeader && contract.tenantId === requesterId,
    );

    // Kiểm tra xem người xóa có phải chủ trọ hoặc trưởng phòng hay không
    if (contract.landlordId !== requesterId && !requesterIsLeader) {
      throw new ForbiddenException(
        'Only the room leader or landlord can remove members',
      );
    }

    const member = members.find((m) => m.id === memberId);
    if (!member) throw new NotFoundException('Member not found');

    // Cập nhật trường leftAt thành thời điểm hiện tại (xóa mềm)
    await this.contractMemberRepo.remove(memberId);
  }
}
