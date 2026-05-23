import { Module } from '@nestjs/common';
import { MulterModule } from '@nestjs/platform-express';
import { memoryStorage } from 'multer';
import { SupabaseModule } from 'src/shared/infrastructure/supabase/supabase.module';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { UploadController } from './upload.controller';
import { UploadService } from './upload.service';

@Module({
  imports: [
    SupabaseModule,
    MulterModule.register({ storage: memoryStorage() }),
  ],
  controllers: [UploadController],
  providers: [UploadService, AuthGuard],
})
export class UploadModule {}
