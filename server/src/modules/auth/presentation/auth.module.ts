import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { RegisterService } from '../application/services/register.service';
import { AuthRepository } from '../domain/repositories/auth.repository';
import { SupabaseAuthRepository } from '../infrastructure/supabase-auth.repository';
import { LoginService } from '../application/services/login.service';

@Module({
  controllers: [AuthController],
  providers: [
    RegisterService,
    LoginService,
    {
      provide: AuthRepository,
      useClass: SupabaseAuthRepository,
    },
  ],
})
export class AuthModule {}
