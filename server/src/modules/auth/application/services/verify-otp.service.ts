import { BadRequestException, Injectable } from '@nestjs/common';
import { RedisService } from 'src/shared/infrastructure/redis/redis.service';
import { VerifyOtpDto } from '../dto/verify-otp.dto';

@Injectable()
export class VerifyOtpService {
  constructor(private readonly redisService: RedisService) {}

  async execute(input: VerifyOtpDto): Promise<{ message: string }> {
    const email = input.email.trim().toLowerCase();
    const otp = input.otp.trim();
    const redisKey = this.getRedisKey(email);

    const storedOtp = await this.redisService.getClient().get(redisKey);

    if (!storedOtp || storedOtp !== otp) {
      throw new BadRequestException('OTP không đúng hoặc đã hết hạn');
    }

    return { message: 'OTP hợp lệ' };
  }

  private getRedisKey(email: string): string {
    return `auth:forgot:${email}`;
  }
}
