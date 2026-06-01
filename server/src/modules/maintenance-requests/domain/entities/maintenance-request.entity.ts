export type MaintenancePriority = 'low' | 'medium' | 'high';

export type MaintenanceRequestStatus =
  | 'pending'
  | 'processing'
  | 'completed'
  | 'rejected'
  | 'complaint';

export class MaintenanceRequestEntity {
  constructor(
    public readonly id: string,
    public readonly tenantId: string,
    public readonly landlordId: string | null,
    public readonly roomId: string | null,
    public readonly title: string,
    public readonly description: string,
    public readonly location: string,
    public readonly priority: MaintenancePriority,
    public readonly status: MaintenanceRequestStatus,
    public readonly imageUrls: string[],
    public readonly complaintImageUrls: string[],
    public readonly technicianName: string | null,
    public readonly technicianPhone: string | null,
    public readonly scheduledAt: Date | null,
    public readonly landlordNote: string | null,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}
}
