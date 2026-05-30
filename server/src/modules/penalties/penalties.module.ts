import { Module } from '@nestjs/common';
import { PenaltiesController } from './penalties.controller';
import { PenaltiesService } from './penalties.service';
import { DrizzleModule } from 'src/shared/infrastructure/database/drizzle.module';
import { SupabaseModule } from 'src/shared/infrastructure/supabase/supabase.module';

@Module({
  imports: [DrizzleModule, SupabaseModule],
  controllers: [PenaltiesController],
  providers: [PenaltiesService],
})
export class PenaltiesModule {}
