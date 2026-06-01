import {
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { RequestPasswordResetService } from '../../../src/modules/auth/application/services/request-password-reset.service';
import { AuthRepository } from '../../../src/modules/auth/domain/repositories/auth.repository';
import { RedisService } from '../../../src/shared/infrastructure/redis/redis.service';
import { MailService } from '../../../src/shared/infrastructure/mail/mail.service';
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
    set: jest.fn(),
  };

  const redisService: jest.Mocked<RedisService> = {
    getClient: jest.fn(() => redisClient as any),
    getValue: jest.fn(),
  } as any;

  const mailService: jest.Mocked<MailService> = {
    sendOtpEmail: jest.fn(),
  } as any;

  const service = new RequestPasswordResetService(
    authRepository,
    redisService,
    mailService,
  );

  return { service, authRepository, redisClient, mailService };
}

describe('RequestPasswordResetService', () => {
  const email = 'user@test.com';

  beforeEach(() => {
    jest.spyOn(Math, 'random').mockReturnValue(0);
  });

  afterEach(() => {
    jest.restoreAllMocks();
  });

  it('sends OTP when user exists', async () => {
    const { service, authRepository, redisClient, mailService } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue('user-1');
    redisClient.set.mockResolvedValue('OK');

    const result = await service.execute({ email });

    expect(result.message).toBe('Mã OTP đã được gửi');
    expect(redisClient.set).toHaveBeenCalled();
    expect(mailService.sendOtpEmail).toHaveBeenCalledWith(email, '100000');
  });

  it('does not send email when user not found', async () => {
    const { service, authRepository, redisClient, mailService } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    redisClient.set.mockResolvedValue('OK');

    await service.execute({ email });

    expect(mailService.sendOtpEmail).not.toHaveBeenCalled();
  });

  it('maps AuthOperationError to bad request', async () => {
    const { service, authRepository } = createService();
    authRepository.findUserIdByEmail.mockRejectedValue(new AuthOperationError('bad'));

    await expect(service.execute({ email }))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('throws internal error when redis fails', async () => {
    const { service, authRepository, redisClient } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue('user-1');
    redisClient.set.mockRejectedValue(new Error('redis error'));

    await expect(service.execute({ email }))
      .rejects
      .toBeInstanceOf(InternalServerErrorException);
  });

  it('handles non-Error throw in catch fallback', async () => {
    const { service, authRepository } = createService();
    authRepository.findUserIdByEmail.mockRejectedValue('something broke');

    await expect(service.execute({ email }))
      .rejects
      .toBeInstanceOf(InternalServerErrorException);
  });
});
