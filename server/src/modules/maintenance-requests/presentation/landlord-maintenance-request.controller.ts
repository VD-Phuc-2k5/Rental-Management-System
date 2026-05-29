import { Body, Controller, Get, Param, Patch, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { Roles } from 'src/shared/common/decorators/roles.decorator';
import { CurrentUser } from 'src/shared/common/decorators/current-user.decorator';

import { GetLandlordMaintenanceRequestsService } from '../application/services/get-landlord-maintenance-requests.service';
import { UpdateMaintenanceStatusService } from '../application/services/update-maintenance-status.service';
import { ScheduleMaintenanceRequestService } from '../application/services/schedule-maintenance-request.service';
import { UpdateMaintenanceStatusDto } from '../application/dto/update-maintenance-status.dto';
import { ScheduleMaintenanceRequestDto } from '../application/dto/schedule-maintenance-request.dto';

@ApiTags('landlord-maintenance-requests')
@Controller('landlord/maintenance-requests')
@UseGuards(AuthGuard, RolesGuard)
@Roles('landlord')
export class LandlordMaintenanceRequestController {
  constructor(
    private readonly getLandlordMaintenanceRequestsService: GetLandlordMaintenanceRequestsService,
    private readonly updateMaintenanceStatusService: UpdateMaintenanceStatusService,
    private readonly scheduleMaintenanceRequestService: ScheduleMaintenanceRequestService,
  ) {}

  @Get()
  async getMaintenanceRequests(@CurrentUser() user: { id: string }) {
    return this.getLandlordMaintenanceRequestsService.execute(user.id);
  }

  @Patch(':id/status')
  async updateStatus(
    @Param('id') id: string,
    @Body() dto: UpdateMaintenanceStatusDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.updateMaintenanceStatusService.execute(id, user.id, dto);
  }

  @Patch(':id/schedule')
  async scheduleMaintenance(
    @Param('id') id: string,
    @Body() dto: ScheduleMaintenanceRequestDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.scheduleMaintenanceRequestService.execute(id, user.id, dto);
  }
}