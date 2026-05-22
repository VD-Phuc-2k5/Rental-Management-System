import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { rooms, properties } from 'src/shared/infrastructure/database/schema';
import { RentalRequestRepository } from '../../domain/repositories/rental-request.repository';
import { RentalRequestEntity } from '../../domain/entities/rental-request.entity';

@Injectable()
export class GetIncomingRequestsService {
  constructor(
    private readonly rentalRequestRepo: RentalRequestRepository,
    private readonly drizzle: DrizzleService,
  ) {}

  async execute(landlordId: string): Promise<RentalRequestEntity[]> {
    const ownedRooms = await this.drizzle.db
      .select({ id: rooms.id })
      .from(rooms)
      .innerJoin(properties, eq(rooms.propertyId, properties.id))
      .where(eq(properties.landlorerId, landlordId));

    if (ownedRooms.length === 0) return [];

    const results: RentalRequestEntity[] = [];
    for (const room of ownedRooms) {
      const requests = await this.rentalRequestRepo.findByRoomId(room.id);
      results.push(...requests);
    }
    return results;
  }
}
