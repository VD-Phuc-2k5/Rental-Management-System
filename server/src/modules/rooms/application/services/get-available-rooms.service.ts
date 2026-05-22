import { Inject } from '@nestjs/common';
import { BrowseRoomRepository, BrowseRoomFilters } from '../../domain/repositories/browse-room.repository';
import { AvailableRoomEntity } from '../../domain/entities/browse-room.entity';

export class GetAvailableRoomsService {
  constructor(
    @Inject(BrowseRoomRepository)
    private readonly browseRoomRepository: BrowseRoomRepository,
  ) {}

  async execute(filters: BrowseRoomFilters): Promise<AvailableRoomEntity[]> {
    return this.browseRoomRepository.findAvailable(filters);
  }
}
