import {
  MaintenancePriority,
  MaintenanceRequestEntity,
  MaintenanceRequestStatus,
} from '../entities/maintenance-request.entity';

export interface CreateMaintenanceRequestInput {
  tenantId: string;
  landlordId: string | null;
  roomId: string | null;
  title: string;
  description: string;
  location: string;
  priority: MaintenancePriority;
  imageUrls: string[];
}

export interface ScheduleMaintenanceRequestInput {
  technicianName?: string | null;
  technicianPhone?: string | null;
  scheduledAt?: Date | null;
  landlordNote?: string | null;
}

export abstract class MaintenanceRequestRepository {
  abstract create(
    input: CreateMaintenanceRequestInput,
  ): Promise<MaintenanceRequestEntity>;

  abstract findByTenantId(
    tenantId: string,
  ): Promise<MaintenanceRequestEntity[]>;

  abstract findByLandlordId(
    landlordId: string,
  ): Promise<MaintenanceRequestEntity[]>;

  abstract updateStatus(
    id: string,
    landlordId: string,
    status: MaintenanceRequestStatus,
  ): Promise<MaintenanceRequestEntity | null>;

  abstract schedule(
    id: string,
    landlordId: string,
    input: ScheduleMaintenanceRequestInput,
  ): Promise<MaintenanceRequestEntity | null>;

  abstract findByIdAndTenantId(
  id: string,
  tenantId: string,
): Promise<MaintenanceRequestEntity | null>;

abstract completeByTenantId(
  id: string,
  tenantId: string,
): Promise<MaintenanceRequestEntity | null>;

abstract submitComplaintByTenantId(
  id: string,
  tenantId: string,
  complaintDescription: string,
): Promise<MaintenanceRequestEntity | null>;
}