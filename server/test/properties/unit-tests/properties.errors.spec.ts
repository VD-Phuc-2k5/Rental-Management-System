import {
  LandlordNotFoundError,
  PropertiesOperationError,
  PropertiesCannotBeCreatedError,
  PropertyNotFoundError,
} from '../../../src/modules/properties/domain/errors/properties.error';

describe('Properties Domain Errors', () => {
  describe('LandlordNotFoundError', () => {
    it('uses default message', () => {
      const error = new LandlordNotFoundError();
      expect(error.message).toBe('Landlord khong ton tai');
      expect(error.name).toBe('LandlordNotFoundError');
      expect(error).toBeInstanceOf(Error);
    });

    it('accepts custom message', () => {
      const error = new LandlordNotFoundError('custom');
      expect(error.message).toBe('custom');
      expect(error.name).toBe('LandlordNotFoundError');
    });
  });

  describe('PropertiesOperationError', () => {
    it('uses provided message', () => {
      const error = new PropertiesOperationError('operation failed');
      expect(error.message).toBe('operation failed');
      expect(error.name).toBe('PropertiesOperationError');
      expect(error).toBeInstanceOf(Error);
    });
  });

  describe('PropertiesCannotBeCreatedError', () => {
    it('uses default message', () => {
      const error = new PropertiesCannotBeCreatedError();
      expect(error.message).toBe('Khong the tao moi khu tro');
      expect(error.name).toBe('PropertiesCannotBeCreatedError');
      expect(error).toBeInstanceOf(Error);
    });

    it('accepts custom message', () => {
      const error = new PropertiesCannotBeCreatedError('custom');
      expect(error.message).toBe('custom');
      expect(error.name).toBe('PropertiesCannotBeCreatedError');
    });
  });

  describe('PropertyNotFoundError', () => {
    it('uses default message', () => {
      const error = new PropertyNotFoundError();
      expect(error.message).toBe('Khu tro khong ton tai');
      expect(error.name).toBe('PropertyNotFoundError');
      expect(error).toBeInstanceOf(Error);
    });

    it('accepts custom message', () => {
      const error = new PropertyNotFoundError('custom');
      expect(error.message).toBe('custom');
      expect(error.name).toBe('PropertyNotFoundError');
    });
  });
});
