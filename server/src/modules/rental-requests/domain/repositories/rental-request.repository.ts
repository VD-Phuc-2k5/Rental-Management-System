import { RentalRequestEntity } from '../entities/rental-request.entity';

export abstract class RentalRequestRepository {
  abstract create(
    tenantId: string,
    roomId: string,
    note: string | null,
  ): Promise<RentalRequestEntity>;
  abstract findByTenantId(tenantId: string): Promise<RentalRequestEntity[]>;
  abstract findById(id: string): Promise<RentalRequestEntity | null>;
  abstract findByRoomId(roomId: string): Promise<RentalRequestEntity[]>;
  abstract updateStatus(
    id: string,
    status: RentalRequestEntity['status'],
  ): Promise<RentalRequestEntity>;
  abstract delete(id: string): Promise<void>;
}
