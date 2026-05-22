export type RentalRequestStatus =
  | 'pending'
  | 'accepted'
  | 'rejected'
  | 'contracted';

export class RentalRequestEntity {
  constructor(
    public readonly id: string,
    public readonly tenantId: string,
    public readonly roomId: string,
    public readonly note: string | null,
    public readonly status: RentalRequestStatus,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}
}
