import { BadRequestException, Inject, Injectable, InternalServerErrorException, Logger } from '@nestjs/common';
import { AuthRepository } from '../../domain/repositories/auth.repository';
import { ResetPasswordDto } from '../dto/reset-password.dto';
import { RedisService } from 'src/shared/infrastructure/redis/redis.service';
import { AuthOperationError } from '../../domain/errors/auth.errors';

@Injectable()
export class ResetPasswordService {
  private readonly logger = new Logger(ResetPasswordService.name);

  constructor(
    @Inject(AuthRepository)
    private readonly authRepository: AuthRepository,
    private readonly redisService: RedisService,
  ) {}

  async execute(input: ResetPasswordDto): Promise<{ message: string }> {
    const email = input.email.trim().toLowerCase();
    const otp = input.otp.trim();

    if (input.newPassword !== input.confirmPassword) {
      throw new BadRequestException('Mật khẩu và xác nhận mật khẩu không khớp');
    }

    const redisKey = this.getRedisKey(email);

    try {
      const storedOtp = await this.redisService.getClient().get(redisKey);

      if (!storedOtp || storedOtp !== otp) {
        throw new BadRequestException('OTP không đúng hoặc đã hết hạn');
      }

      const userId = await this.authRepository.findUserIdByEmail(email);

      if (!userId) {
        throw new BadRequestException('Người dùng không tồn tại');
      }

      await this.authRepository.updatePassword(userId, input.newPassword);
      await this.redisService.getClient().del(redisKey);

      return { message: 'Đặt lại mật khẩu thành công' };
    } catch (error) {
      this.logger.error(
        'Reset password flow failed',
        error instanceof Error ? error.stack : String(error),
      );

      if (error instanceof BadRequestException) {
        throw error;
      }

      if (error instanceof AuthOperationError) {
        throw new BadRequestException(error.message);
      }

      throw new InternalServerErrorException('Không thể đặt lại mật khẩu lúc này');
    }
  }

  private getRedisKey(email: string): string {
    return `auth:forgot:${email}`;
  }
}
