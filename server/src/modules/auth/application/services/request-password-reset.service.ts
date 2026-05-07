import { BadRequestException, Inject, Injectable, InternalServerErrorException, Logger } from '@nestjs/common';
import { AuthRepository } from '../../domain/repositories/auth.repository';
import { ForgotPasswordDto } from '../dto/forgot-password.dto';
import { RedisService } from 'src/shared/infrastructure/redis/redis.service';
import { MailService } from 'src/shared/infrastructure/mail/mail.service';
import { AuthOperationError } from '../../domain/errors/auth.errors';

@Injectable()
export class RequestPasswordResetService {
  private readonly logger = new Logger(RequestPasswordResetService.name);
  private readonly otpTtlSeconds = 60;

  constructor(
    @Inject(AuthRepository)
    private readonly authRepository: AuthRepository,
    private readonly redisService: RedisService,
    private readonly mailService: MailService,
  ) {}

  async execute(input: ForgotPasswordDto): Promise<{ message: string }> {
    const email = input.email.trim().toLowerCase();
    const otp = this.generateOtp();
    const redisKey = this.getRedisKey(email);

    try {
      const userId = await this.authRepository.findUserIdByEmail(email);

      await this.redisService
        .getClient()
        .set(redisKey, otp, 'EX', this.otpTtlSeconds);

      if (userId) {
        await this.mailService.sendOtpEmail(email, otp);
      }

      return {
        message: 'Mã OTP đã được gửi',
      };
    } catch (error) {
      this.logger.error(
        'Forgot password flow failed',
        error instanceof Error ? error.stack : String(error),
      );

      if (error instanceof AuthOperationError) {
        throw new BadRequestException(error.message);
      }

      throw new InternalServerErrorException('Không thể xử lý yêu cầu lúc này');
    }
  }

  private getRedisKey(email: string): string {
    return `auth:forgot:${email}`;
  }

  private generateOtp(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }
}
