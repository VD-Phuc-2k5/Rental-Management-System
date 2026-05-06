import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { RegisterService } from '../application/services/register.service';
import { AuthRepository } from '../domain/repositories/auth.repository';
import { SupabaseAuthRepository } from '../infrastructure/supabase-auth.repository';
import { LoginService } from '../application/services/login.service';
import { UsersModule } from '../../users/presentation/user.module';
import { MailModule } from '../../../shared/infrastructure/mail/mail.module';
import { RedisModule } from '../../../shared/infrastructure/redis/redis.module';
import { RequestPasswordResetService } from '../application/services/request-password-reset.service';
import { ResetPasswordService } from '../application/services/reset-password.service';
import { VerifyOtpService } from '../application/services/verify-otp.service';

@Module({
  imports: [UsersModule, MailModule, RedisModule],
  controllers: [AuthController],
  providers: [
    RegisterService,
    LoginService,
    RequestPasswordResetService,
    ResetPasswordService,
    VerifyOtpService,
    {
      provide: AuthRepository,
      useClass: SupabaseAuthRepository,
    },
  ],
})
export class AuthModule {}
