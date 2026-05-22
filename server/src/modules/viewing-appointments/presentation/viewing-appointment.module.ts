import { Module } from '@nestjs/common';
import { DrizzleModule } from 'src/shared/infrastructure/database/drizzle.module';
import { SupabaseModule } from 'src/shared/infrastructure/supabase/supabase.module';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { ViewingAppointmentController } from './viewing-appointment.controller';
import { LandlordViewingAppointmentController } from './landlord-viewing-appointment.controller';
import { DrizzleViewingAppointmentRepository } from '../infrastructure/drizzle-viewing-appointment.repository';
import { ViewingAppointmentRepository } from '../domain/repositories/viewing-appointment.repository';
import { CreateViewingAppointmentService } from '../application/services/create-viewing-appointment.service';
import { GetMyViewingAppointmentsService } from '../application/services/get-my-viewing-appointments.service';
import { GetLandlordViewingAppointmentsService } from '../application/services/get-landlord-viewing-appointments.service';
import { ApproveViewingAppointmentService } from '../application/services/approve-viewing-appointment.service';
import { RejectViewingAppointmentService } from '../application/services/reject-viewing-appointment.service';
import { CancelViewingAppointmentService } from '../application/services/cancel-viewing-appointment.service';

@Module({
  imports: [DrizzleModule, SupabaseModule],
  controllers: [
    ViewingAppointmentController,
    LandlordViewingAppointmentController,
  ],
  providers: [
    AuthGuard,
    RolesGuard,
    {
      provide: ViewingAppointmentRepository,
      useClass: DrizzleViewingAppointmentRepository,
    },
    CreateViewingAppointmentService,
    GetMyViewingAppointmentsService,
    GetLandlordViewingAppointmentsService,
    ApproveViewingAppointmentService,
    RejectViewingAppointmentService,
    CancelViewingAppointmentService,
  ],
})
export class ViewingAppointmentsModule {}
