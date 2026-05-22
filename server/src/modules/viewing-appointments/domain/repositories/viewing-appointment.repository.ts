import {
  ViewingAppointmentEntity,
  ViewingAppointmentStatus,
} from '../entities/viewing-appointment.entity';

export abstract class ViewingAppointmentRepository {
  abstract create(
    tenantId: string,
    roomId: string,
    scheduledAt: Date,
    note: string | null,
  ): Promise<ViewingAppointmentEntity>;

  abstract findByTenantId(
    tenantId: string,
  ): Promise<ViewingAppointmentEntity[]>;

  abstract findByRoomId(roomId: string): Promise<ViewingAppointmentEntity[]>;

  abstract findById(id: string): Promise<ViewingAppointmentEntity | null>;

  abstract updateStatus(
    id: string,
    status: ViewingAppointmentStatus,
  ): Promise<ViewingAppointmentEntity>;
}
