import { Module } from '@nestjs/common';
import { MulterModule } from '@nestjs/platform-express';
import { memoryStorage } from 'multer';
import { DrizzleModule } from 'src/shared/infrastructure/database/drizzle.module';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { BillingController } from './billing.controller';
import { BillingService } from './services/billing.service';

@Module({
  imports: [DrizzleModule, MulterModule.register({ storage: memoryStorage() })],
  controllers: [BillingController],
  providers: [AuthGuard, RolesGuard, BillingService],
})
export class BillingModule {}
