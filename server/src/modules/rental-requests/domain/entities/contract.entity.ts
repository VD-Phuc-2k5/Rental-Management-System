export type ContractStatus =
  | 'draft'
  | 'sent'
  | 'signed'
  | 'cancelled'
  | 'finished';

export class ContractEntity {
  constructor(
    public readonly id: string,
    public readonly rentalRequestId: string | null,
    public readonly roomId: string,
    public readonly tenantId: string,
    public readonly landlordId: string,
    public readonly startDate: string,
    public readonly endDate: string,
    public readonly monthlyRent: string,
    public readonly deposit: string,
    public readonly status: ContractStatus,
    public readonly terms: string | null,
    public readonly sentAt: Date | null,
    public readonly signedAt: Date | null,
    public readonly cancelledAt: Date | null,
    public readonly finishedAt: Date | null,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}
}
