import { Module } from '@nestjs/common';

import { DrizzleModule } from 'src/shared/infrastructure/database/drizzle.module';
import { SupabaseModule } from 'src/shared/infrastructure/supabase/supabase.module';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';

import { MaintenanceRequestController } from './maintenance-request.controller';
import { LandlordMaintenanceRequestController } from './landlord-maintenance-request.controller';

import { MaintenanceRequestRepository } from '../domain/repositories/maintenance-request.repository';
import { DrizzleMaintenanceRequestRepository } from '../infrastructure/drizzle-maintenance-request.repository';

import { CreateMaintenanceRequestService } from '../application/services/create-maintenance-request.service';
import { GetMyMaintenanceRequestsService } from '../application/services/get-my-maintenance-requests.service';
import { GetLandlordMaintenanceRequestsService } from '../application/services/get-landlord-maintenance-requests.service';
import { UpdateMaintenanceStatusService } from '../application/services/update-maintenance-status.service';
import { ScheduleMaintenanceRequestService } from '../application/services/schedule-maintenance-request.service';
import { CompleteMaintenanceRequestService } from '../application/services/complete-maintenance-request.service';
import { GetMaintenanceRequestDetailService } from '../application/services/get-maintenance-request-detail.service';
import { SubmitMaintenanceComplaintService } from '../application/services/submit-maintenance-complaint.service';
@Module({
  imports: [DrizzleModule, SupabaseModule],
  controllers: [
    MaintenanceRequestController,
    LandlordMaintenanceRequestController,
  ],
  providers: [
    AuthGuard,
    RolesGuard,
    {
      provide: MaintenanceRequestRepository,
      useClass: DrizzleMaintenanceRequestRepository,
    },
    CreateMaintenanceRequestService,
    GetMyMaintenanceRequestsService,
    GetLandlordMaintenanceRequestsService,
    UpdateMaintenanceStatusService,
    ScheduleMaintenanceRequestService,
    CompleteMaintenanceRequestService,
    GetMaintenanceRequestDetailService,
    SubmitMaintenanceComplaintService,
  ],
})
export class MaintenanceRequestsModule {}