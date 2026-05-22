export type ViewingAppointmentStatus =
  | 'pending'
  | 'approved'
  | 'rejected'
  | 'cancelled';

export class ViewingAppointmentEntity {
  constructor(
    public readonly id: string,
    public readonly tenantId: string,
    public readonly roomId: string,
    public readonly scheduledAt: Date,
    public readonly status: ViewingAppointmentStatus,
    public readonly note: string | null,
    public readonly createdAt: Date,
    public readonly updatedAt: Date,
  ) {}
}
