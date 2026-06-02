import { GetAvailableRoomsService } from '../../../src/modules/rooms/application/services/get-available-rooms.service';
import { BrowseRoomRepository } from '../../../src/modules/rooms/domain/repositories/browse-room.repository';
import { AvailableRoomEntity } from '../../../src/modules/rooms/domain/entities/browse-room.entity';

describe('GetAvailableRoomsService', () => {
  function createService() {
    const browseRoomRepository: jest.Mocked<BrowseRoomRepository> = {
      findAvailable: jest.fn(),
      findDetailById: jest.fn(),
    };

    const service = new GetAvailableRoomsService(browseRoomRepository);
    return { service, browseRoomRepository };
  }

  function makeRoom(id = 'room-1'): AvailableRoomEntity {
    return new AvailableRoomEntity(
      id,
      'Phong 101',
      'AVAILABLE',
      '25',
      '3000000',
      '6000000',
      'property-1',
      'Chung cu A',
      '123 Duong Le Loi, Q1, HCM',
      null,
    );
  }

  // EP-12: Không filter — trả về tất cả
  it('returns all available rooms when no filter is provided', async () => {
    const { service, browseRoomRepository } = createService();
    const rooms = [makeRoom('room-1'), makeRoom('room-2')];
    browseRoomRepository.findAvailable.mockResolvedValue(rooms);

    const result = await service.execute({});

    expect(result).toHaveLength(2);
    expect(browseRoomRepository.findAvailable).toHaveBeenCalledWith({});
  });

  // EP-13: Filter minRent >= 2tr
  it('filters rooms with minRent', async () => {
    const { service, browseRoomRepository } = createService();
    const rooms = [makeRoom()];
    browseRoomRepository.findAvailable.mockResolvedValue(rooms);

    const result = await service.execute({ minRent: 2000000 });

    expect(result).toEqual(rooms);
    expect(browseRoomRepository.findAvailable).toHaveBeenCalledWith({
      minRent: 2000000,
    });
  });

  // EP-14: Filter maxRent <= 5tr
  it('filters rooms with maxRent', async () => {
    const { service, browseRoomRepository } = createService();
    const rooms = [makeRoom()];
    browseRoomRepository.findAvailable.mockResolvedValue(rooms);

    const result = await service.execute({ maxRent: 5000000 });

    expect(result).toEqual(rooms);
    expect(browseRoomRepository.findAvailable).toHaveBeenCalledWith({
      maxRent: 5000000,
    });
  });

  // EP-15: Filter cả minRent và maxRent
  it('filters rooms with both minRent and maxRent', async () => {
    const { service, browseRoomRepository } = createService();
    const rooms = [makeRoom()];
    browseRoomRepository.findAvailable.mockResolvedValue(rooms);

    const result = await service.execute({
      minRent: 2000000,
      maxRent: 5000000,
    });

    expect(result).toEqual(rooms);
    expect(browseRoomRepository.findAvailable).toHaveBeenCalledWith({
      minRent: 2000000,
      maxRent: 5000000,
    });
  });

  it('returns empty array when no rooms match filters', async () => {
    const { service, browseRoomRepository } = createService();
    browseRoomRepository.findAvailable.mockResolvedValue([]);

    const result = await service.execute({ minRent: 999999999 });

    expect(result).toEqual([]);
  });
});
