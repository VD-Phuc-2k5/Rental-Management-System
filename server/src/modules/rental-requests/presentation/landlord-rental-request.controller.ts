import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  UseGuards,
} from '@nestjs/common';
import { ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { Roles } from 'src/shared/common/decorators/roles.decorator';
import { CurrentUser } from 'src/shared/common/decorators/current-user.decorator';
import { UpdateContractDto } from '../application/dto/update-contract.dto';
import { GetIncomingRequestsService } from '../application/services/get-incoming-requests.service';
import { RejectRentalRequestService } from '../application/services/reject-rental-request.service';
import { GetLandlordContractsService } from '../application/services/get-landlord-contracts.service';
import { UpdateContractService } from '../application/services/update-contract.service';
import { SendContractService } from '../application/services/send-contract.service';
import { FinishContractService } from '../application/services/finish-contract.service';
import { GetContractByRentalRequestService } from '../application/services/get-contract-by-rental-request.service';

@ApiTags('landlord-rental-requests')
@Controller('landlord')
@UseGuards(AuthGuard, RolesGuard)
@Roles('landlord')
export class LandlordRentalRequestController {
  constructor(
    private readonly getIncomingRequestsService: GetIncomingRequestsService,
    private readonly rejectRentalRequestService: RejectRentalRequestService,
    private readonly getLandlordContractsService: GetLandlordContractsService,
    private readonly updateContractService: UpdateContractService,
    private readonly sendContractService: SendContractService,
    private readonly finishContractService: FinishContractService,
    private readonly getContractByRentalRequestService: GetContractByRentalRequestService,
  ) {}

  @Get('rental-requests')
  async getIncomingRequests(@CurrentUser() user: { id: string }) {
    return this.getIncomingRequestsService.execute(user.id);
  }

  @Patch('rental-requests/:id/reject')
  async rejectRequest(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    await this.rejectRentalRequestService.execute(id, user.id);
    return { success: true };
  }

  @Get('contracts')
  async getLandlordContracts(@CurrentUser() user: { id: string }) {
    return this.getLandlordContractsService.execute(user.id);
  }

  @Patch('contracts/:id')
  async updateContract(
    @Param('id') id: string,
    @Body() dto: UpdateContractDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.updateContractService.execute(id, user.id, dto);
  }

  @Post('contracts/:id/send')
  async sendContract(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.sendContractService.execute(id, user.id);
  }

  @Post('contracts/:id/finish')
  async finishContract(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.finishContractService.execute(id, user.id);
  }

  @Get('rental-requests/:rentalRequestId/contract')
  async getContractByRentalRequest(
    @Param('rentalRequestId') rentalRequestId: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.getContractByRentalRequestService.execute(
      rentalRequestId,
      user.id,
    );
  }
}
