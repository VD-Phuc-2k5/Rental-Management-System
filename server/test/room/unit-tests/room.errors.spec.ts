import {
  RoomNotFoundError,
  RoomCannotBeCreatedError,
} from '../../../src/modules/rooms/domain/errors/room.errors';

describe('Room Domain Errors', () => {
  describe('RoomNotFoundError', () => {
    it('uses default message', () => {
      const error = new RoomNotFoundError();
      expect(error.message).toBe('Phong khong ton tai');
      expect(error.name).toBe('RoomNotFoundError');
    });

    it('accepts custom message', () => {
      const error = new RoomNotFoundError('custom');
      expect(error.message).toBe('custom');
      expect(error.name).toBe('RoomNotFoundError');
    });
  });

  describe('RoomCannotBeCreatedError', () => {
    it('uses default message', () => {
      const error = new RoomCannotBeCreatedError();
      expect(error.message).toBe('Khong the tao phong');
      expect(error.name).toBe('RoomCannotBeCreatedError');
    });

    it('accepts custom message', () => {
      const error = new RoomCannotBeCreatedError('custom');
      expect(error.message).toBe('custom');
      expect(error.name).toBe('RoomCannotBeCreatedError');
    });

    it('extends Error', () => {
      const error = new RoomCannotBeCreatedError('msg');
      expect(error).toBeInstanceOf(Error);
    });
  });
});
