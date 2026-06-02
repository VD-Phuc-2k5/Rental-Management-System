import { InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { BrowseRoomController } from '../../../src/modules/rooms/presentation/browse-room.controller';
import { GetAvailableRoomsService } from '../../../src/modules/rooms/application/services/get-available-rooms.service';
import { GetBrowseRoomDetailService } from '../../../src/modules/rooms/application/services/get-browse-room-detail.service';
import { AvailableRoomEntity, BrowseRoomDetailEntity } from '../../../src/modules/rooms/domain/entities/browse-room.entity';

describe('BrowseRoomController', () => {
  let controller: BrowseRoomController;
  let getAvailableRoomsService: jest.Mocked<GetAvailableRoomsService>;
  let getBrowseRoomDetailService: jest.Mocked<GetBrowseRoomDetailService>;

  beforeEach(() => {
    getAvailableRoomsService = { execute: jest.fn() } as any;
    getBrowseRoomDetailService = { execute: jest.fn() } as any;

    controller = new BrowseRoomController(
      getAvailableRoomsService,
      getBrowseRoomDetailService,
    );
  });

  // EP-12: Không filter
  describe('getAvailableRooms', () => {
    it('returns all available rooms without filters (EP-12)', async () => {
      const rooms = [
        new AvailableRoomEntity('r1', 'Phong 1', 'AVAILABLE', '25', '3000000', '6000000', 'p1', 'Property', 'Addr', null),
      ];
      getAvailableRoomsService.execute.mockResolvedValue(rooms);

      const result = await controller.getAvailableRooms(undefined, undefined);

      expect(result).toEqual(rooms);
      expect(getAvailableRoomsService.execute).toHaveBeenCalledWith({});
    });

    // EP-13: Filter minRent
    it('passes minRent query param (EP-13)', async () => {
      getAvailableRoomsService.execute.mockResolvedValue([]);

      await controller.getAvailableRooms('2000000', undefined);

      expect(getAvailableRoomsService.execute).toHaveBeenCalledWith({ minRent: 2000000 });
    });

    // EP-14: Filter maxRent
    it('passes maxRent query param (EP-14)', async () => {
      getAvailableRoomsService.execute.mockResolvedValue([]);

      await controller.getAvailableRooms(undefined, '5000000');

      expect(getAvailableRoomsService.execute).toHaveBeenCalledWith({ maxRent: 5000000 });
    });

    // EP-15: Filter cả 2
    it('passes both minRent and maxRent (EP-15)', async () => {
      getAvailableRoomsService.execute.mockResolvedValue([]);

      await controller.getAvailableRooms('2000000', '5000000');

      expect(getAvailableRoomsService.execute).toHaveBeenCalledWith({
        minRent: 2000000,
        maxRent: 5000000,
      });
    });
  });

  // ROOM-22/23: Get room detail
  describe('getRoomDetail', () => {
    it('returns room detail when found (ROOM-22)', async () => {
      const detail = new BrowseRoomDetailEntity(
        'room-1', 'Phong 101', 'AVAILABLE', '25', '3000000', '6000000',
        '3500', '15000', false, null, [], [], 'p1', 'Property', 'Addr',
        'Landlord', null, [],
      );
      getBrowseRoomDetailService.execute.mockResolvedValue(detail);

      const result = await controller.getRoomDetail('room-1');

      expect(result).toEqual(detail);
    });

    it('throws NotFoundException when room missing (ROOM-23)', async () => {
      getBrowseRoomDetailService.execute.mockRejectedValue(new NotFoundException());

      await expect(controller.getRoomDetail('bad-id')).rejects.toBeInstanceOf(NotFoundException);
    });

    it('throws InternalServerErrorException on unknown error', async () => {
      getBrowseRoomDetailService.execute.mockRejectedValue(new Error('boom'));

      await expect(controller.getRoomDetail('room-1')).rejects.toBeInstanceOf(InternalServerErrorException);
    });
  });
});
