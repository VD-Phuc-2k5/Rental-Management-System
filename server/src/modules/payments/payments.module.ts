import { Module } from '@nestjs/common';
import { DrizzleModule } from 'src/shared/infrastructure/database/drizzle.module';
import { SupabaseModule } from 'src/shared/infrastructure/supabase/supabase.module';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { RolesGuard } from 'src/shared/common/guards/roles.guard';
import { ContractRepository } from '../rental-requests/domain/repositories/contract.repository';
import { DrizzleContractRepository } from '../rental-requests/infrastructure/drizzle-contract.repository';
import { RentalRequestRepository } from '../rental-requests/domain/repositories/rental-request.repository';
import { DrizzleRentalRequestRepository } from '../rental-requests/infrastructure/drizzle-rental-request.repository';
import { SignContractService } from '../rental-requests/application/services/sign-contract.service';
import { VnpayService } from './vnpay.service';
import { PayosService } from './payos.service';
import { PaymentsController } from './payments.controller';

@Module({
  imports: [DrizzleModule, SupabaseModule],
  controllers: [PaymentsController],
  providers: [
    AuthGuard,
    RolesGuard,
    { provide: ContractRepository, useClass: DrizzleContractRepository },
    {
      provide: RentalRequestRepository,
      useClass: DrizzleRentalRequestRepository,
    },
    SignContractService,
    VnpayService,
    PayosService,
  ],
})
export class PaymentsModule {}
