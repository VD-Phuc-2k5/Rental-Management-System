import {
  Injectable,
  Logger,
  OnModuleDestroy,
  OnModuleInit,
} from '@nestjs/common';
import { ContractRepository } from '../../domain/repositories/contract.repository';

@Injectable()
export class ContractCleanupService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(ContractCleanupService.name);
  private intervalId: NodeJS.Timeout | null = null;

  constructor(private readonly contractRepo: ContractRepository) {}

  onModuleInit() {
    this.intervalId = setInterval(
      () => this.cleanupCancelledContracts(),
      60 * 60 * 1000,
    );
  }

  onModuleDestroy() {
    if (this.intervalId) clearInterval(this.intervalId);
  }

  async cleanupCancelledContracts(): Promise<void> {
    const cutoff = new Date(Date.now() - 24 * 60 * 60 * 1000);
    const stale = await this.contractRepo.findCancelledBefore(cutoff);
    for (const contract of stale) {
      await this.contractRepo.deleteById(contract.id);
      this.logger.log(`Deleted stale cancelled contract ${contract.id}`);
    }
  }
}
