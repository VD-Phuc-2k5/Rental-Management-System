import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import {
  rooms,
  properties,
  contractMembers,
} from 'src/shared/infrastructure/database/schema';
import { RentalRequestRepository } from '../../domain/repositories/rental-request.repository';
import { ContractRepository } from '../../domain/repositories/contract.repository';
import {
  RentalRequestEntity,
  MemberInfo,
  VehicleInfo,
} from '../../domain/entities/rental-request.entity';

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
    memberInfo: MemberInfo[] = [],
    parkingInfo: VehicleInfo[] = [],
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

    const existingContracts = await this.contractRepo.findByRoomId(roomId);
    const hasActiveContract = existingContracts.some((c) =>
      ['draft', 'sent', 'signed'].includes(c.status),
    );
    if (hasActiveContract) {
      throw new BadRequestException(
        'Room already has an active contract. Please wait until it is resolved.',
      );
    }

    const request = await this.rentalRequestRepo.create(
      tenantId,
      roomId,
      prop.landlorerId,
      note,
      memberInfo,
      parkingInfo,
    );

    const today = new Date();
    const startDate = today.toISOString().split('T')[0];
    const endDate = new Date(new Date().setFullYear(today.getFullYear() + 1))
      .toISOString()
      .split('T')[0];

    const contract = await this.contractRepo.create(
      request.id,
      roomId,
      tenantId,
      prop.landlorerId,
      startDate,
      endDate,
      room.monthlyRent,
      room.depositAmount,
    );

    if (memberInfo.length > 0) {
      await this.drizzle.db.insert(contractMembers).values(
        memberInfo.map((m) => ({
          contractId: contract.id,
          fullName: m.fullName,
          phone: m.phone ?? null,
          identityNumber: m.identityNumber ?? null,
          email: m.email ?? null,
          address: m.address ?? null,
          isRoomLeader: m.isRoomLeader,
          identityImageUrl: m.identityImageUrl ?? null,
          dateOfBirth: m.dateOfBirth ?? null,
        })),
      );
    }

    return request;
  }
}
