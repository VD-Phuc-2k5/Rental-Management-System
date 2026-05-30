import { Controller, Post, Get, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { PenaltiesService } from './penalties.service';
import { CreatePenaltyDto } from './dto/create-penalty.dto';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { Roles } from 'src/shared/common/decorators/roles.decorator';

@ApiTags('penalties')
@Controller('penalties')
@UseGuards(AuthGuard, RolesGuard)
export class PenaltiesController {
  constructor(private readonly penaltiesService: PenaltiesService) {}

  // Chỉ Chủ trọ mới được quyền tạo phiếu phạt
  @Post()
  @Roles('landlord')
  async createPenalty(@Body() dto: CreatePenaltyDto) {
    return this.penaltiesService.create(dto);
  }

  // Cả Chủ trọ và Người thuê đều có thể xem danh sách phạt của phòng mình
  @Get('contract/:contractId')
  @Roles('landlord', 'tenant')
  async getPenaltiesByContract(@Param('contractId') contractId: string) {
    return this.penaltiesService.getByContract(contractId);
  }
}
