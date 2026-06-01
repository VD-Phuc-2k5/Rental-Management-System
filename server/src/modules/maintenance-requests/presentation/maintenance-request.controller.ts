import { Body, Controller, Get, Param, Patch, Post, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';

import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { Roles } from 'src/shared/common/decorators/roles.decorator';
import { CurrentUser } from 'src/shared/common/decorators/current-user.decorator';

import { CreateMaintenanceRequestDto } from '../application/dto/create-maintenance-request.dto';
import { CreateMaintenanceRequestService } from '../application/services/create-maintenance-request.service';
import { GetMyMaintenanceRequestsService } from '../application/services/get-my-maintenance-requests.service';
import { CompleteMaintenanceRequestService } from '../application/services/complete-maintenance-request.service';
import { GetMaintenanceRequestDetailService } from '../application/services/get-maintenance-request-detail.service';
import { SubmitMaintenanceComplaintDto } from '../application/dto/submit-maintenance-complaint.dto';
import { SubmitMaintenanceComplaintService } from '../application/services/submit-maintenance-complaint.service';
@ApiTags('maintenance-requests')
@Controller('maintenance-requests')
@UseGuards(AuthGuard, RolesGuard)
export class MaintenanceRequestController {
  constructor(
    private readonly createMaintenanceRequestService: CreateMaintenanceRequestService,
    private readonly getMyMaintenanceRequestsService: GetMyMaintenanceRequestsService,
    private readonly completeMaintenanceRequestService: CompleteMaintenanceRequestService,
    private readonly getMaintenanceRequestDetailService: GetMaintenanceRequestDetailService,
    private readonly submitMaintenanceComplaintService: SubmitMaintenanceComplaintService,
  ) {}

  @Post()
  @Roles('tenant')
  async createMaintenanceRequest(
    @Body() dto: CreateMaintenanceRequestDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.createMaintenanceRequestService.execute(user.id, dto);
  }
  @Patch(':id/complete')
  @Roles('tenant')
  async completeMaintenanceRequest(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.completeMaintenanceRequestService.execute(id, user.id);
  }
  @Get('mine')
  @Roles('tenant')
  async getMyMaintenanceRequests(@CurrentUser() user: { id: string }) {
    return this.getMyMaintenanceRequestsService.execute(user.id);
  }

  @Get(':id')
  @Roles('tenant')
  async getMaintenanceRequestDetail(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.getMaintenanceRequestDetailService.execute(id, user.id);
  }

  @Patch(':id/complaint')
  @Roles('tenant')
  async submitComplaint(
    @Param('id') id: string,
    @Body() dto: SubmitMaintenanceComplaintDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.submitMaintenanceComplaintService.execute(id, user.id, dto);
  }
}