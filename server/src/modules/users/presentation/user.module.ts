import { Module } from '@nestjs/common';
import { UsersController } from './user.controller';
import { ProfileController } from './profile.controller';
import { UserRepository } from '../domain/repositories/user.repository';
import { CreateUserService } from '../application/services/create-user.service';
import { DrizzleUserRepository } from '../infrastructure/drizzle-user.repository';
import { DrizzleModule } from '../../../shared/infrastructure/database/drizzle.module';
import { FindUserService } from '../application/services/find-user.service';
import { GetProfileService } from '../application/services/get-profile.service';
import { UpdateProfileService } from '../application/services/update-profile.service';
import { SupabaseModule } from 'src/shared/infrastructure/supabase/supabase.module';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';

@Module({
  imports: [DrizzleModule, SupabaseModule],
  controllers: [UsersController, ProfileController],
  providers: [
    CreateUserService,
    FindUserService,
    GetProfileService,
    UpdateProfileService,
    AuthGuard,
    {
      provide: UserRepository,
      useClass: DrizzleUserRepository,
    },
  ],
  exports: [UserRepository],
})
export class UsersModule {}
