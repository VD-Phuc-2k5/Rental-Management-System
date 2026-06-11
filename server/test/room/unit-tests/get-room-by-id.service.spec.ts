import { NotFoundException } from '@nestjs/common';
import { GetRoomByIdService } from '../../../src/modules/rooms/application/services/get-room-by-id.service';
import { RoomRepository } from '../../../src/modules/rooms/domain/repositories/room.repository';
import { RoomEntity } from '../../../src/modules/rooms/domain/entities/room.entity';

describe('GetRoomByIdService', () => {
  const roomId = 'room-1';

  function createService() {
    const roomRepository: jest.Mocked<RoomRepository> = {
      createRoom: jest.fn(),
      findAllByPropertyId: jest.fn(),
      findById: jest.fn(),
      updateRoom: jest.fn(),
      deleteRoom: jest.fn(),
    };

    const service = new GetRoomByIdService(roomRepository);
    return { service, roomRepository };
  }

  function makeRoom(): RoomEntity {
    return new RoomEntity(
      roomId,
      'property-1',
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

  // ROOM-10: Get room by ID thành công
  it('returns room when it exists', async () => {
    const { service, roomRepository } = createService();
    const room = makeRoom();
    roomRepository.findById.mockResolvedValue(room);

    const result = await service.execute(roomId);

    expect(result).toEqual(room);
    expect(roomRepository.findById).toHaveBeenCalledWith(roomId);
  });

  // ROOM-11: Get room by ID không tồn tại
  it('throws NotFoundException when room does not exist', async () => {
    const { service, roomRepository } = createService();
    roomRepository.findById.mockResolvedValue(null);

    await expect(service.execute(roomId)).rejects.toBeInstanceOf(NotFoundException);
    expect(roomRepository.findById).toHaveBeenCalledWith(roomId);
  });
});
