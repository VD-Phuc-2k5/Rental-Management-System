import { AvailableRoomEntity, BrowseRoomDetailEntity } from '../entities/browse-room.entity';

export type BrowseRoomFilters = {
  minRent?: number;
  maxRent?: number;
};

export abstract class BrowseRoomRepository {
  abstract findAvailable(filters: BrowseRoomFilters): Promise<AvailableRoomEntity[]>;
  abstract findDetailById(id: string): Promise<BrowseRoomDetailEntity | null>;
}
