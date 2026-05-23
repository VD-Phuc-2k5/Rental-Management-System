import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { contractMembers } from 'src/shared/infrastructure/database/schema';
import { ContractMemberEntity } from '../domain/entities/contract-member.entity';
import { ContractMemberRepository } from '../domain/repositories/contract-member.repository';

@Injectable()
export class DrizzleContractMemberRepository implements ContractMemberRepository {
  constructor(private readonly drizzle: DrizzleService) {}

  private toEntity(
    row: typeof contractMembers.$inferSelect,
  ): ContractMemberEntity {
    return new ContractMemberEntity(
      row.id,
      row.contractId,
      row.fullName,
      row.phone,
      row.identityNumber,
      row.email,
      row.address,
      row.isRoomLeader,
      row.leftAt,
      row.createdAt,
      row.updatedAt,
    );
  }

  async findByContractId(contractId: string): Promise<ContractMemberEntity[]> {
    const rows = await this.drizzle.db
      .select()
      .from(contractMembers)
      .where(eq(contractMembers.contractId, contractId));
    return rows.map(this.toEntity.bind(this));
  }

  async remove(id: string): Promise<void> {
    await this.drizzle.db
      .update(contractMembers)
      .set({ leftAt: new Date(), updatedAt: new Date() })
      .where(eq(contractMembers.id, id));
  }
}
