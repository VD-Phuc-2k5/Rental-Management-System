import {
  AuthOperationError,
  DuplicateEmailError,
  InvalidCredentialsError,
} from '../../../src/modules/auth/domain/errors/auth.errors';

describe('Auth Domain Errors', () => {
  describe('DuplicateEmailError', () => {
    it('uses default message', () => {
      const error = new DuplicateEmailError();
      expect(error.message).toBe(
        'Email đã được sử dụng, vui lòng sử dụng email khác',
      );
      expect(error.name).toBe('DuplicateEmailError');
    });

    it('accepts custom message', () => {
      const error = new DuplicateEmailError('custom');
      expect(error.message).toBe('custom');
      expect(error.name).toBe('DuplicateEmailError');
    });
  });

  describe('InvalidCredentialsError', () => {
    it('uses default message', () => {
      const error = new InvalidCredentialsError();
      expect(error.message).toBe('Email hoặc mật khẩu không đúng');
      expect(error.name).toBe('InvalidCredentialsError');
    });

    it('accepts custom message', () => {
      const error = new InvalidCredentialsError('custom');
      expect(error.message).toBe('custom');
      expect(error.name).toBe('InvalidCredentialsError');
    });
  });

  describe('AuthOperationError', () => {
    it('stores given message', () => {
      const error = new AuthOperationError('operation failed');
      expect(error.message).toBe('operation failed');
      expect(error.name).toBe('AuthOperationError');
    });

    it('extends Error', () => {
      const error = new AuthOperationError('msg');
      expect(error).toBeInstanceOf(Error);
    });
  });
});
