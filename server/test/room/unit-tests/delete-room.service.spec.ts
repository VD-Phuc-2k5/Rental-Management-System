import { NotFoundException } from '@nestjs/common';
import { DeleteRoomService } from '../../../src/modules/rooms/application/services/delete-room.service';
import { RoomRepository } from '../../../src/modules/rooms/domain/repositories/room.repository';
import { RoomEntity } from '../../../src/modules/rooms/domain/entities/room.entity';

describe('DeleteRoomService', () => {
  const roomId = 'room-1';

  function createService() {
    const roomRepository: jest.Mocked<RoomRepository> = {
      createRoom: jest.fn(),
      findAllByPropertyId: jest.fn(),
      findById: jest.fn(),
      updateRoom: jest.fn(),
      deleteRoom: jest.fn(),
    };

    const service = new DeleteRoomService(roomRepository);
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

  // ROOM-16: Delete room thành công
  it('deletes room when it exists', async () => {
    const { service, roomRepository } = createService();
    roomRepository.findById.mockResolvedValue(makeRoom());
    roomRepository.deleteRoom.mockResolvedValue(undefined);

    await service.execute(roomId);

    expect(roomRepository.findById).toHaveBeenCalledWith(roomId);
    expect(roomRepository.deleteRoom).toHaveBeenCalledWith(roomId);
  });

  // ROOM-17: Delete room không tồn tại
  it('throws NotFoundException when room does not exist', async () => {
    const { service, roomRepository } = createService();
    roomRepository.findById.mockResolvedValue(null);

    await expect(service.execute(roomId)).rejects.toBeInstanceOf(NotFoundException);
    expect(roomRepository.findById).toHaveBeenCalledWith(roomId);
    expect(roomRepository.deleteRoom).not.toHaveBeenCalled();
  });
});
