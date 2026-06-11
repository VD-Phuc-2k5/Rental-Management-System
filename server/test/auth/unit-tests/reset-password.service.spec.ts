import {
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { ResetPasswordService } from '../../../src/modules/auth/application/services/reset-password.service';
import { AuthRepository } from '../../../src/modules/auth/domain/repositories/auth.repository';
import { RedisService } from '../../../src/shared/infrastructure/redis/redis.service';
import { AuthOperationError } from '../../../src/modules/auth/domain/errors/auth.errors';

function createService() {
  const authRepository: jest.Mocked<AuthRepository> = {
    register: jest.fn(),
    deleteUser: jest.fn(),
    login: jest.fn(),
    findUserIdByEmail: jest.fn(),
    updatePassword: jest.fn(),
  };

  const redisClient = {
    del: jest.fn(),
  };

  const redisService: jest.Mocked<RedisService> = {
    getClient: jest.fn(() => redisClient as any),
    getValue: jest.fn(),
  } as any;

  const service = new ResetPasswordService(authRepository, redisService);
  return { service, authRepository, redisService, redisClient };
}

describe('ResetPasswordService', () => {
  const baseInput = {
    email: 'user@test.com',
    otp: '123456',
    newPassword: 'NewPass1@',
    confirmPassword: 'NewPass1@',
  };

  it('throws when password confirmation mismatched', async () => {
    const { service } = createService();

    await expect(
      service.execute({ ...baseInput, confirmPassword: 'Diff1@erent' }),
    ).rejects.toBeInstanceOf(BadRequestException);
  });

  it('throws when OTP not found', async () => {
    const { service, redisService } = createService();
    redisService.getValue.mockResolvedValue(null);

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('throws when OTP mismatched and not verified', async () => {
    const { service, redisService } = createService();
    redisService.getValue.mockResolvedValue({ otp: '000000', isVerified: false });

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('throws when user not found', async () => {
    const { service, redisService, authRepository } = createService();
    redisService.getValue.mockResolvedValue({ otp: '123456', isVerified: true });
    authRepository.findUserIdByEmail.mockResolvedValue(null);

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('updates password and clears OTP when valid', async () => {
    const { service, redisService, authRepository, redisClient } = createService();
    redisService.getValue.mockResolvedValue({ otp: '123456', isVerified: true });
    authRepository.findUserIdByEmail.mockResolvedValue('user-1');
    authRepository.updatePassword.mockResolvedValue();
    redisClient.del.mockResolvedValue(1);

    const result = await service.execute({ ...baseInput });

    expect(result.message).toBe('Đặt lại mật khẩu thành công');
    expect(authRepository.updatePassword).toHaveBeenCalledWith('user-1', baseInput.newPassword);
    expect(redisClient.del).toHaveBeenCalled();
  });

  it('maps AuthOperationError to bad request', async () => {
    const { service, redisService, authRepository } = createService();
    redisService.getValue.mockResolvedValue({ otp: '123456', isVerified: true });
    authRepository.findUserIdByEmail.mockResolvedValue('user-1');
    authRepository.updatePassword.mockRejectedValue(new AuthOperationError('bad'));

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('throws internal error for unexpected errors', async () => {
    const { service, redisService } = createService();
    redisService.getValue.mockRejectedValue(new Error('redis error'));

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(InternalServerErrorException);
  });

  it('proceeds when OTP mismatched but already verified', async () => {
    const { service, redisService, authRepository, redisClient } = createService();
    redisService.getValue.mockResolvedValue({ otp: '000000', isVerified: true });
    authRepository.findUserIdByEmail.mockResolvedValue('user-1');
    authRepository.updatePassword.mockResolvedValue();
    redisClient.del.mockResolvedValue(1);

    const result = await service.execute({ ...baseInput });

    expect(result.message).toBe('Đặt lại mật khẩu thành công');
    expect(authRepository.updatePassword).toHaveBeenCalledWith('user-1', baseInput.newPassword);
  });
});
