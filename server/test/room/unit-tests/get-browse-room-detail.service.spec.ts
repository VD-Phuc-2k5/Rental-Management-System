import { NotFoundException } from '@nestjs/common';
import { GetBrowseRoomDetailService } from '../../../src/modules/rooms/application/services/get-browse-room-detail.service';
import { BrowseRoomRepository } from '../../../src/modules/rooms/domain/repositories/browse-room.repository';
import { BrowseRoomDetailEntity } from '../../../src/modules/rooms/domain/entities/browse-room.entity';

describe('GetBrowseRoomDetailService', () => {
  const roomId = 'room-1';

  function createService() {
    const browseRoomRepository: jest.Mocked<BrowseRoomRepository> = {
      findAvailable: jest.fn(),
      findDetailById: jest.fn(),
    };

    const service = new GetBrowseRoomDetailService(browseRoomRepository);
    return { service, browseRoomRepository };
  }

  function makeDetail(): BrowseRoomDetailEntity {
    return new BrowseRoomDetailEntity(
      roomId,
      'Phong 101',
      'AVAILABLE',
      '25',
      '3000000',
      '6000000',
      '3500',
      '15000',
      false,
      null,
      [],
      [],
      'property-1',
      'Chung cu A',
      '123 Duong Le Loi, Q1, HCM',
      'Nguyen Van A',
      null,
      [],
    );
  }

  // ROOM-22: Get room detail thành công
  it('returns room detail when room exists', async () => {
    const { service, browseRoomRepository } = createService();
    const detail = makeDetail();
    browseRoomRepository.findDetailById.mockResolvedValue(detail);

    const result = await service.execute(roomId);

    expect(result).toEqual(detail);
    expect(browseRoomRepository.findDetailById).toHaveBeenCalledWith(roomId);
  });

  // ROOM-23: Get room detail không tồn tại
  it('throws NotFoundException when room does not exist', async () => {
    const { service, browseRoomRepository } = createService();
    browseRoomRepository.findDetailById.mockResolvedValue(null);

    await expect(service.execute(roomId)).rejects.toBeInstanceOf(
      NotFoundException,
    );
    expect(browseRoomRepository.findDetailById).toHaveBeenCalledWith(roomId);
  });
});
