import { BadRequestException, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { RoomController } from '../../../src/modules/rooms/presentation/room.controller';
import { CreateRoomService } from '../../../src/modules/rooms/application/services/create-room.service';
import { GetRoomsService } from '../../../src/modules/rooms/application/services/get-rooms.service';
import { GetRoomByIdService } from '../../../src/modules/rooms/application/services/get-room-by-id.service';
import { UpdateRoomService } from '../../../src/modules/rooms/application/services/update-room.service';
import { DeleteRoomService } from '../../../src/modules/rooms/application/services/delete-room.service';
import { CreateRoomDto } from '../../../src/modules/rooms/application/dto/create-room.dto';
import { UpdateRoomDto } from '../../../src/modules/rooms/application/dto/update-room.dto';
import { RoomEntity } from '../../../src/modules/rooms/domain/entities/room.entity';

describe('RoomController', () => {
  let controller: RoomController;
  let createRoomService: jest.Mocked<CreateRoomService>;
  let getRoomsService: jest.Mocked<GetRoomsService>;
  let getRoomByIdService: jest.Mocked<GetRoomByIdService>;
  let updateRoomService: jest.Mocked<UpdateRoomService>;
  let deleteRoomService: jest.Mocked<DeleteRoomService>;

  const mockUser = { id: 'landlord-1', email: '', phone: null, full_name: '', avartar_url: null, roles: ['landlord'] };

  function makeRoom(): RoomEntity {
    return new RoomEntity(
      'room-1', 'property-1', 'Phong 101', 'AVAILABLE', '25', '3000000',
      '6000000', '3500', '15000', false, null, [], [],
      new Date().toISOString(), new Date().toISOString(),
    );
  }

  beforeEach(() => {
    createRoomService = { execute: jest.fn() } as any;
    getRoomsService = { execute: jest.fn() } as any;
    getRoomByIdService = { execute: jest.fn() } as any;
    updateRoomService = { execute: jest.fn() } as any;
    deleteRoomService = { execute: jest.fn() } as any;

    controller = new RoomController(
      createRoomService,
      getRoomsService,
      getRoomByIdService,
      updateRoomService,
      deleteRoomService,
    );
  });

  // ROOM-01: Create room thành công
  describe('createRoom', () => {
    it('returns created room (ROOM-01)', async () => {
      const dto = new CreateRoomDto();
      const room = makeRoom();
      createRoomService.execute.mockResolvedValue(room);

      const result = await controller.createRoom('property-1', dto, mockUser as any);

      expect(result).toEqual(room);
      expect(createRoomService.execute).toHaveBeenCalledWith('property-1', 'landlord-1', dto);
    });

    // ROOM-02: Property không tồn tại
    it('throws NotFoundException when property not found (ROOM-02)', async () => {
      createRoomService.execute.mockRejectedValue(new NotFoundException());

      await expect(
        controller.createRoom('bad-id', new CreateRoomDto(), mockUser as any),
      ).rejects.toBeInstanceOf(NotFoundException);
    });

    it('throws BadRequestException when dto is invalid', async () => {
      createRoomService.execute.mockRejectedValue(new BadRequestException());

      await expect(
        controller.createRoom('property-1', new CreateRoomDto(), mockUser as any),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('throws InternalServerErrorException on unknown error', async () => {
      createRoomService.execute.mockRejectedValue(new Error('db error'));

      await expect(
        controller.createRoom('property-1', new CreateRoomDto(), mockUser as any),
      ).rejects.toBeInstanceOf(InternalServerErrorException);
    });
  });

  // ROOM-09: Get rooms by property
  describe('getRooms', () => {
    it('returns rooms for property (ROOM-09)', async () => {
      const rooms = [makeRoom()];
      getRoomsService.execute.mockResolvedValue(rooms);

      const result = await controller.getRooms('property-1');

      expect(result).toEqual(rooms);
      expect(getRoomsService.execute).toHaveBeenCalledWith('property-1');
    });
  });

  // ROOM-10/11: Get room by ID
  describe('getRoomById', () => {
    it('returns room when found (ROOM-10)', async () => {
      const room = makeRoom();
      getRoomByIdService.execute.mockResolvedValue(room);

      const result = await controller.getRoomById('room-1');

      expect(result).toEqual(room);
    });

    it('throws NotFoundException when not found (ROOM-11)', async () => {
      getRoomByIdService.execute.mockRejectedValue(new NotFoundException());

      await expect(controller.getRoomById('bad-id')).rejects.toBeInstanceOf(NotFoundException);
    });

    it('throws InternalServerErrorException on unknown error', async () => {
      getRoomByIdService.execute.mockRejectedValue(new Error('boom'));

      await expect(controller.getRoomById('room-1')).rejects.toBeInstanceOf(InternalServerErrorException);
    });
  });

  // ROOM-12/13/14: Update room
  describe('updateRoom', () => {
    it('updates room title (ROOM-12)', async () => {
      const dto = new UpdateRoomDto();
      dto.title = 'Updated';
      const room = makeRoom();
      updateRoomService.execute.mockResolvedValue(room);

      const result = await controller.updateRoom('room-1', dto);

      expect(result).toEqual(room);
      expect(updateRoomService.execute).toHaveBeenCalledWith('room-1', dto);
    });

    it('throws NotFoundException when room missing (ROOM-17)', async () => {
      updateRoomService.execute.mockRejectedValue(new NotFoundException());

      await expect(
        controller.updateRoom('bad-id', new UpdateRoomDto()),
      ).rejects.toBeInstanceOf(NotFoundException);
    });

    it('throws InternalServerErrorException on unknown error', async () => {
      updateRoomService.execute.mockRejectedValue(new Error('boom'));

      await expect(
        controller.updateRoom('room-1', new UpdateRoomDto()),
      ).rejects.toBeInstanceOf(InternalServerErrorException);
    });
  });

  // ROOM-16/17: Delete room
  describe('deleteRoom', () => {
    it('deletes room successfully (ROOM-16)', async () => {
      deleteRoomService.execute.mockResolvedValue(undefined);

      await expect(
        controller.deleteRoom('room-1'),
      ).resolves.toBeUndefined();
      expect(deleteRoomService.execute).toHaveBeenCalledWith('room-1');
    });

    it('throws NotFoundException when room missing (ROOM-17)', async () => {
      deleteRoomService.execute.mockRejectedValue(new NotFoundException());

      await expect(controller.deleteRoom('bad-id')).rejects.toBeInstanceOf(NotFoundException);
    });

    it('throws InternalServerErrorException on unknown error', async () => {
      deleteRoomService.execute.mockRejectedValue(new Error('boom'));

      await expect(controller.deleteRoom('room-1')).rejects.toBeInstanceOf(InternalServerErrorException);
    });
  });
});
