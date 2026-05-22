import { Module } from '@nestjs/common';
import { DrizzleModule } from 'src/shared/infrastructure/database/drizzle.module';
import { SupabaseModule } from 'src/shared/infrastructure/supabase/supabase.module';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { RentalRequestController } from './rental-request.controller';
import { LandlordRentalRequestController } from './landlord-rental-request.controller';
import { DrizzleRentalRequestRepository } from '../infrastructure/drizzle-rental-request.repository';
import { DrizzleContractRepository } from '../infrastructure/drizzle-contract.repository';
import { RentalRequestRepository } from '../domain/repositories/rental-request.repository';
import { ContractRepository } from '../domain/repositories/contract.repository';
import { CreateRentalRequestService } from '../application/services/create-rental-request.service';
import { GetMyRentalRequestsService } from '../application/services/get-my-rental-requests.service';
import { CancelRentalRequestService } from '../application/services/cancel-rental-request.service';
import { GetIncomingRequestsService } from '../application/services/get-incoming-requests.service';
import { RejectRentalRequestService } from '../application/services/reject-rental-request.service';
import { GetMyContractsService } from '../application/services/get-my-contracts.service';
import { GetContractDetailService } from '../application/services/get-contract-detail.service';
import { SignContractService } from '../application/services/sign-contract.service';
import { CancelContractService } from '../application/services/cancel-contract.service';
import { GetLandlordContractsService } from '../application/services/get-landlord-contracts.service';
import { UpdateContractService } from '../application/services/update-contract.service';
import { SendContractService } from '../application/services/send-contract.service';
import { FinishContractService } from '../application/services/finish-contract.service';

@Module({
  imports: [DrizzleModule, SupabaseModule],
  controllers: [RentalRequestController, LandlordRentalRequestController],
  providers: [
    AuthGuard,
    RolesGuard,
    {
      provide: RentalRequestRepository,
      useClass: DrizzleRentalRequestRepository,
    },
    { provide: ContractRepository, useClass: DrizzleContractRepository },
    CreateRentalRequestService,
    GetMyRentalRequestsService,
    CancelRentalRequestService,
    GetIncomingRequestsService,
    RejectRentalRequestService,
    GetMyContractsService,
    GetContractDetailService,
    SignContractService,
    CancelContractService,
    GetLandlordContractsService,
    UpdateContractService,
    SendContractService,
    FinishContractService,
  ],
})
export class RentalRequestsModule {}
