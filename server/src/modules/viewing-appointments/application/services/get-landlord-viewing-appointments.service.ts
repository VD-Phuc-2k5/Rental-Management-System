import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { rooms, properties } from 'src/shared/infrastructure/database/schema';
import { ViewingAppointmentRepository } from '../../domain/repositories/viewing-appointment.repository';
import { ViewingAppointmentEntity } from '../../domain/entities/viewing-appointment.entity';

@Injectable()
export class GetLandlordViewingAppointmentsService {
  constructor(
    private readonly repo: ViewingAppointmentRepository,
    private readonly drizzle: DrizzleService,
  ) {}

  async execute(landlordId: string): Promise<ViewingAppointmentEntity[]> {
    const ownedRooms = await this.drizzle.db
      .select({ id: rooms.id })
      .from(rooms)
      .innerJoin(properties, eq(rooms.propertyId, properties.id))
      .where(eq(properties.landlorerId, landlordId));

    if (ownedRooms.length === 0) return [];

    const results: ViewingAppointmentEntity[] = [];
    for (const room of ownedRooms) {
      const appts = await this.repo.findByRoomId(room.id);
      results.push(...appts);
    }
    return results;
  }
}
