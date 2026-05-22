import { Injectable, NotFoundException } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { rooms, properties } from 'src/shared/infrastructure/database/schema';
import { RentalRequestRepository } from '../../domain/repositories/rental-request.repository';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import { RentalRequestEntity } from '../../domain/entities/rental-request.entity';

@Injectable()
export class CreateRentalRequestService {
  constructor(
    private readonly rentalRequestRepo: RentalRequestRepository,
    private readonly contractRepo: ContractRepository,
    private readonly drizzle: DrizzleService,
  ) {}

  async execute(
    tenantId: string,
    roomId: string,
    note: string | null,
  ): Promise<RentalRequestEntity> {
    const [room] = await this.drizzle.db
      .select({
        propertyId: rooms.propertyId,
        monthlyRent: rooms.monthly_rent,
        depositAmount: rooms.deposit_amount,
      })
      .from(rooms)
      .where(eq(rooms.id, roomId));

    if (!room) throw new NotFoundException('Room not found');

    const [prop] = await this.drizzle.db
      .select({ landlorerId: properties.landlorerId })
      .from(properties)
      .where(eq(properties.id, room.propertyId));

    if (!prop) throw new NotFoundException('Property not found');

    const request = await this.rentalRequestRepo.create(tenantId, roomId, note);

    const today = new Date();
    const startDate = today.toISOString().split('T')[0];
    const endDate = new Date(new Date().setFullYear(today.getFullYear() + 1))
      .toISOString()
      .split('T')[0];

    await this.contractRepo.create(
      request.id,
      roomId,
      tenantId,
      prop.landlorerId,
      startDate,
      endDate,
      room.monthlyRent,
      room.depositAmount,
    );

    return request;
  }
}
