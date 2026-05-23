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
import { CreateRentalRequestDto } from '../application/dto/create-rental-request.dto';
import { CreateRentalRequestService } from '../application/services/create-rental-request.service';
import { GetMyRentalRequestsService } from '../application/services/get-my-rental-requests.service';
import { CancelRentalRequestService } from '../application/services/cancel-rental-request.service';
import { GetMyContractsService } from '../application/services/get-my-contracts.service';
import { GetContractDetailService } from '../application/services/get-contract-detail.service';
import { SignContractService } from '../application/services/sign-contract.service';
import { CancelContractService } from '../application/services/cancel-contract.service';
import { GetContractMembersService } from '../application/services/get-contract-members.service';
import { RemoveContractMemberService } from '../application/services/remove-contract-member.service';

@ApiTags('rental-requests')
@Controller()
@UseGuards(AuthGuard, RolesGuard)
export class RentalRequestController {
  constructor(
    private readonly createRentalRequestService: CreateRentalRequestService,
    private readonly getMyRentalRequestsService: GetMyRentalRequestsService,
    private readonly cancelRentalRequestService: CancelRentalRequestService,
    private readonly getMyContractsService: GetMyContractsService,
    private readonly getContractDetailService: GetContractDetailService,
    private readonly signContractService: SignContractService,
    private readonly cancelContractService: CancelContractService,
    private readonly getContractMembersService: GetContractMembersService,
    private readonly removeContractMemberService: RemoveContractMemberService,
  ) {}

  @Post('rental-requests')
  @Roles('tenant')
  async createRentalRequest(
    @Body() dto: CreateRentalRequestDto,
    @CurrentUser() user: { id: string },
  ) {
    return this.createRentalRequestService.execute(
      user.id,
      dto.roomId,
      dto.note ?? null,
      dto.memberInfo ?? [],
      dto.parkingInfo ?? [],
    );
  }

  @Get('rental-requests/mine')
  @Roles('tenant')
  async getMyRentalRequests(@CurrentUser() user: { id: string }) {
    return this.getMyRentalRequestsService.execute(user.id);
  }

  @Delete('rental-requests/:id')
  @Roles('tenant')
  @HttpCode(HttpStatus.NO_CONTENT)
  async cancelRentalRequest(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    await this.cancelRentalRequestService.execute(id, user.id);
  }

  @Get('contracts/mine')
  @Roles('tenant')
  async getMyContracts(@CurrentUser() user: { id: string }) {
    return this.getMyContractsService.execute(user.id);
  }

  @Get('contracts/:id')
  async getContractDetail(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.getContractDetailService.execute(id, user.id);
  }

  @Post('contracts/:id/sign')
  @Roles('tenant')
  async signContract(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.signContractService.execute(id, user.id);
  }

  @Post('contracts/:id/cancel')
  @Roles('tenant')
  async cancelContract(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.cancelContractService.execute(id, user.id);
  }

  @Get('contracts/:id/members')
  async getContractMembers(
    @Param('id') id: string,
    @CurrentUser() user: { id: string },
  ) {
    return this.getContractMembersService.execute(id, user.id);
  }

  @Delete('contracts/:contractId/members/:memberId')
  @HttpCode(HttpStatus.NO_CONTENT)
  async removeContractMember(
    @Param('contractId') contractId: string,
    @Param('memberId') memberId: string,
    @CurrentUser() user: { id: string },
  ) {
    await this.removeContractMemberService.execute(
      contractId,
      memberId,
      user.id,
    );
  }
}
