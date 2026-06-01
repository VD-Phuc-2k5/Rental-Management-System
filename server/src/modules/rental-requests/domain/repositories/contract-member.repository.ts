import { ContractMemberEntity } from '../entities/contract-member.entity';

export abstract class ContractMemberRepository {
  abstract findByContractId(
    contractId: string,
  ): Promise<ContractMemberEntity[]>;
  abstract remove(id: string): Promise<void>;
}
