import {
  Controller,
  Get,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { Roles } from 'src/shared/common/decorators/roles.decorator';
import { CurrentUser } from 'src/shared/common/decorators/current-user.decorator';
import { GetLandlordViewingAppointmentsService } from '../application/services/get-landlord-viewing-appointments.service';
import { ApproveViewingAppointmentService } from '../application/services/approve-viewing-appointment.service';
import { RejectViewingAppointmentService } from '../application/services/reject-viewing-appointment.service';

@ApiTags('viewing-appointments')
@Controller()
@UseGuards(AuthGuard, RolesGuard)
export class LandlordViewingAppointmentController {
  constructor(
    private readonly getLandlordService: GetLandlordViewingAppointmentsService,
    private readonly approveService: ApproveViewingAppointmentService,
    private readonly rejectService: RejectViewingAppointmentService,
  ) {}

  @Get('landlord/viewing-appointments')
  @Roles('landlord')
  async getLandlordAppointments(@CurrentUser() user: { id: string }) {
    return this.getLandlordService.execute(user.id);
  }

  @Post('landlord/viewing-appointments/:id/approve')
  @Roles('landlord')
  async approve(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.approveService.execute(id, user.id);
  }

  @Post('landlord/viewing-appointments/:id/reject')
  @Roles('landlord')
  async reject(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.rejectService.execute(id, user.id);
  }
}
