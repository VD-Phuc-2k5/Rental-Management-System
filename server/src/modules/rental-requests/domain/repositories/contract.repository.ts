import { ContractEntity } from '../entities/contract.entity';

export interface UpdateContractData {
  startDate?: string;
  endDate?: string;
  monthlyRent?: string;
  deposit?: string;
  terms?: string;
}

export abstract class ContractRepository {
  abstract create(
    rentalRequestId: string,
    roomId: string,
    tenantId: string,
    landlordId: string,
    startDate: string,
    endDate: string,
    monthlyRent: string,
    deposit: string,
  ): Promise<ContractEntity>;
  abstract findByTenantId(tenantId: string): Promise<ContractEntity[]>;
  abstract findByLandlordId(landlordId: string): Promise<ContractEntity[]>;
  abstract findById(id: string): Promise<ContractEntity | null>;
  abstract update(
    id: string,
    data: UpdateContractData,
  ): Promise<ContractEntity>;
  abstract updateStatus(
    id: string,
    status: ContractEntity['status'],
    timestampField?: 'sentAt' | 'signedAt' | 'cancelledAt' | 'finishedAt',
  ): Promise<ContractEntity>;
}
