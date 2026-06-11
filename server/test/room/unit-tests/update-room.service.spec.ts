import { NotFoundException } from '@nestjs/common';
import { UpdateRoomService } from '../../../src/modules/rooms/application/services/update-room.service';
import { RoomRepository } from '../../../src/modules/rooms/domain/repositories/room.repository';
import { RoomEntity } from '../../../src/modules/rooms/domain/entities/room.entity';

describe('UpdateRoomService', () => {
  const roomId = 'room-1';

  function createService() {
    const roomRepository: jest.Mocked<RoomRepository> = {
      createRoom: jest.fn(),
      findAllByPropertyId: jest.fn(),
      findById: jest.fn(),
      updateRoom: jest.fn(),
      deleteRoom: jest.fn(),
    };

    const service = new UpdateRoomService(roomRepository);
    return { service, roomRepository };
  }

  function makeRoom(overrides?: Partial<RoomEntity>): RoomEntity {
    return new RoomEntity(
      overrides?.id ?? roomId,
      overrides?.propertyId ?? 'property-1',
      overrides?.title ?? 'Phong 101',
      overrides?.status ?? 'AVAILABLE',
      overrides?.area_sqm ?? '25',
      overrides?.monthly_rent ?? '3000000',
      overrides?.deposit_amount ?? '6000000',
      overrides?.electricity_rate_per_kwh ?? '3500',
      overrides?.water_rate_per_m3 ?? '15000',
      overrides?.has_furniture ?? false,
      overrides?.description ?? null,
      overrides?.included_amenity_codes ?? [],
      overrides?.addon_amenities ?? [],
      overrides?.createdAt ?? new Date().toISOString(),
      overrides?.updatedAt ?? new Date().toISOString(),
    );
  }

  // ROOM-12: Update room title
  it('updates room title', async () => {
    const { service, roomRepository } = createService();
    const existingRoom = makeRoom();
    const updatedRoom = makeRoom({ title: 'Phong 101 Updated' });
    roomRepository.findById.mockResolvedValue(existingRoom);
    roomRepository.updateRoom.mockResolvedValue(updatedRoom);

    const result = await service.execute(roomId, { title: 'Phong 101 Updated' });

    expect(result.title).toBe('Phong 101 Updated');
    expect(roomRepository.updateRoom).toHaveBeenCalledWith(roomId, {
      title: 'Phong 101 Updated',
    });
  });

  // ROOM-13: Update room status = OCCUPIED
  it('updates room status to OCCUPIED (EP-09)', async () => {
    const { service, roomRepository } = createService();
    const existingRoom = makeRoom();
    const updatedRoom = makeRoom({ status: 'OCCUPIED' });
    roomRepository.findById.mockResolvedValue(existingRoom);
    roomRepository.updateRoom.mockResolvedValue(updatedRoom);

    const result = await service.execute(roomId, { status: 'OCCUPIED' });

    expect(result.status).toBe('OCCUPIED');
    expect(roomRepository.updateRoom).toHaveBeenCalledWith(roomId, {
      status: 'OCCUPIED',
    });
  });

  // ROOM-14: Update room status = MAINTENANCE
  it('updates room status to MAINTENANCE (EP-10)', async () => {
    const { service, roomRepository } = createService();
    const existingRoom = makeRoom();
    const updatedRoom = makeRoom({ status: 'MAINTENANCE' });
    roomRepository.findById.mockResolvedValue(existingRoom);
    roomRepository.updateRoom.mockResolvedValue(updatedRoom);

    const result = await service.execute(roomId, { status: 'MAINTENANCE' });

    expect(result.status).toBe('MAINTENANCE');
    expect(roomRepository.updateRoom).toHaveBeenCalledWith(roomId, {
      status: 'MAINTENANCE',
    });
  });

  // ROOM-17 (reuse): Update room không tồn tại
  it('throws NotFoundException when room does not exist', async () => {
    const { service, roomRepository } = createService();
    roomRepository.findById.mockResolvedValue(null);

    await expect(
      service.execute(roomId, { title: 'Updated' }),
    ).rejects.toBeInstanceOf(NotFoundException);
    expect(roomRepository.updateRoom).not.toHaveBeenCalled();
  });
});
