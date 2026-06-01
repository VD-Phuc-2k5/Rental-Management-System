import { BadRequestException } from '@nestjs/common';
import { VerifyOtpService } from '../../../src/modules/auth/application/services/verify-otp.service';
import { RedisService } from '../../../src/shared/infrastructure/redis/redis.service';

function createService() {
  const redisClient = {
    set: jest.fn(),
  };

  const redisService: jest.Mocked<RedisService> = {
    getClient: jest.fn(() => redisClient as any),
    getValue: jest.fn(),
  } as any;

  const service = new VerifyOtpService(redisService);
  return { service, redisService, redisClient };
}

describe('VerifyOtpService', () => {
  const email = 'user@test.com';
  const otp = '123456';

  it('throws when OTP not found', async () => {
    const { service, redisService } = createService();
    redisService.getValue.mockResolvedValue(null);

    await expect(service.execute({ email, otp }))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('throws when OTP mismatched', async () => {
    const { service, redisService } = createService();
    redisService.getValue.mockResolvedValue({ otp: '000000', isVerified: false });

    await expect(service.execute({ email, otp }))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('marks OTP as verified', async () => {
    const { service, redisService, redisClient } = createService();
    redisService.getValue.mockResolvedValue({ otp: '123456', isVerified: false });
    redisClient.set.mockResolvedValue('OK');

    const result = await service.execute({ email, otp });

    expect(result.message).toBe('OTP hợp lệ');
    expect(redisClient.set).toHaveBeenCalled();
  });
});
