export type RentalRequestStatus =
  | 'pending'
  | 'accepted'
  | 'rejected'
  | 'contracted';

export interface MemberInfo {
  fullName: string;
  phone?: string;
  identityNumber?: string;
  identityImageUrl?: string;
  email?: string;
  address?: string;
  dateOfBirth?: string;
  isRoomLeader: boolean;
}

export interface VehicleInfo {
  type: string;
  plate: string;
  quantity: number;
}

export class RentalRequestEntity {
  constructor(
    public readonly id: string,
    public readonly tenantId: string,
    public readonly roomId: string,
    public readonly landlordId: string | null,
    public readonly note: string | null,
    public readonly memberInfo: MemberInfo[],
    public readonly parkingInfo: VehicleInfo[],
    public readonly status: RentalRequestStatus,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
    public readonly roomTitle: string | null = null,
  ) {}
}
