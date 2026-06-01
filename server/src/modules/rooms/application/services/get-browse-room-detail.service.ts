import { Inject, NotFoundException } from '@nestjs/common';
import { BrowseRoomRepository } from '../../domain/repositories/browse-room.repository';
import { BrowseRoomDetailEntity } from '../../domain/entities/browse-room.entity';

export class GetBrowseRoomDetailService {
  constructor(
    @Inject(BrowseRoomRepository)
    private readonly browseRoomRepository: BrowseRoomRepository,
  ) {}

  async execute(id: string): Promise<BrowseRoomDetailEntity> {
    const room = await this.browseRoomRepository.findDetailById(id);
    if (!room) throw new NotFoundException(`Room ${id} not found`);
    return room;
  }
}
