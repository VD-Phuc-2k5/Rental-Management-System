import { Injectable } from '@nestjs/common';
import { eq, desc } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { penalties } from 'src/shared/infrastructure/database/schema';
import { CreatePenaltyDto } from './dto/create-penalty.dto';

@Injectable()
export class PenaltiesService {
  constructor(private readonly drizzle: DrizzleService) {}

  async create(dto: CreatePenaltyDto) {
    const [penalty] = await this.drizzle.db
      .insert(penalties)
      .values({
        contractId: dto.contractId,
        tenantId: dto.tenantId,
        roomId: dto.roomId,
        amount: dto.amount.toString(),
        reason: dto.reason,
      })
      .returning();

    return penalty;
  }

  async getByContract(contractId: string) {
    const list = await this.drizzle.db
      .select()
      .from(penalties)
      .where(eq(penalties.contractId, contractId))
      .orderBy(desc(penalties.createdAt));

    return list;
  }
}
