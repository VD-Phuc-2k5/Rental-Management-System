import { GetRoomsService } from '../../../src/modules/rooms/application/services/get-rooms.service';
import { RoomRepository } from '../../../src/modules/rooms/domain/repositories/room.repository';
import { RoomEntity } from '../../../src/modules/rooms/domain/entities/room.entity';

describe('GetRoomsService', () => {
  const propertyId = 'property-1';

  function createService() {
    const roomRepository: jest.Mocked<RoomRepository> = {
      createRoom: jest.fn(),
      findAllByPropertyId: jest.fn(),
      findById: jest.fn(),
      updateRoom: jest.fn(),
      deleteRoom: jest.fn(),
    };

    const service = new GetRoomsService(roomRepository);
    return { service, roomRepository };
  }

  function makeRoom(id: string): RoomEntity {
    return new RoomEntity(
      id,
      propertyId,
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
      new Date().toISOString(),
      new Date().toISOString(),
    );
  }

  // ROOM-09: Get rooms by property — EP thành công
  it('returns rooms for a given property', async () => {
    const { service, roomRepository } = createService();
    const rooms = [makeRoom('room-1'), makeRoom('room-2')];
    roomRepository.findAllByPropertyId.mockResolvedValue(rooms);

    const result = await service.execute(propertyId);

    expect(result).toEqual(rooms);
    expect(roomRepository.findAllByPropertyId).toHaveBeenCalledWith(propertyId);
  });

  it('returns empty array when property has no rooms', async () => {
    const { service, roomRepository } = createService();
    roomRepository.findAllByPropertyId.mockResolvedValue([]);

    const result = await service.execute(propertyId);

    expect(result).toEqual([]);
  });
});
