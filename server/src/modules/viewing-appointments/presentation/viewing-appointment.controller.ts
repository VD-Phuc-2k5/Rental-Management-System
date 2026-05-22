import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { Roles } from 'src/shared/common/decorators/roles.decorator';
import { CurrentUser } from 'src/shared/common/decorators/current-user.decorator';
import { CreateViewingAppointmentDto } from '../application/dto/create-viewing-appointment.dto';
import { CreateViewingAppointmentService } from '../application/services/create-viewing-appointment.service';
import { GetMyViewingAppointmentsService } from '../application/services/get-my-viewing-appointments.service';
import { CancelViewingAppointmentService } from '../application/services/cancel-viewing-appointment.service';

@ApiTags('viewing-appointments')
@Controller()
@UseGuards(AuthGuard, RolesGuard)
export class ViewingAppointmentController {
  constructor(
    private readonly createService: CreateViewingAppointmentService,
    private readonly getMyService: GetMyViewingAppointmentsService,
    private readonly cancelService: CancelViewingAppointmentService,
  ) {}

  @Post('viewing-appointments')
  @Roles('tenant')
  async create(
    @Body() dto: CreateViewingAppointmentDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.createService.execute(
      user.id,
      dto.roomId,
      new Date(dto.scheduledAt),
      dto.note ?? null,
    );
  }

  @Get('viewing-appointments/mine')
  @Roles('tenant')
  async getMine(@CurrentUser() user: { id: string }) {
    return this.getMyService.execute(user.id);
  }

  @Delete('viewing-appointments/:id')
  @Roles('tenant')
  @HttpCode(HttpStatus.NO_CONTENT)
  async cancel(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    await this.cancelService.execute(id, user.id);
  }
}
