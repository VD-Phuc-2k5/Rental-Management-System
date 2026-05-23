import { Injectable } from '@nestjs/common';
import { and, eq, gte, inArray, lte, notInArray } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import {
  contracts,
  properties,
  roomImages,
  rooms,
  users,
} from 'src/shared/infrastructure/database/schema';
import {
  AvailableRoomEntity,
  BrowseRoomDetailEntity,
} from '../domain/entities/browse-room.entity';
import { RoomStatus } from '../domain/entities/room.entity';
import {
  BrowseRoomFilters,
  BrowseRoomRepository,
} from '../domain/repositories/browse-room.repository';

@Injectable()
export class DrizzleBrowseRoomRepository implements BrowseRoomRepository {
  constructor(private readonly drizzleService: DrizzleService) {}

  async findAvailable(
    filters: BrowseRoomFilters,
  ): Promise<AvailableRoomEntity[]> {
    // Rooms with a 'sent' contract are awaiting tenant signature — hide from list
    const roomsWithSentContract = await this.drizzleService.db
      .select({ roomId: contracts.roomId })
      .from(contracts)
      .where(eq(contracts.status, 'sent'));

    const blockedRoomIds = roomsWithSentContract.map((r) => r.roomId);

    const conditions = [eq(rooms.status, 'AVAILABLE')];
    if (blockedRoomIds.length > 0)
      conditions.push(notInArray(rooms.id, blockedRoomIds));
    if (filters.minRent !== undefined)
      conditions.push(gte(rooms.monthly_rent, String(filters.minRent)));
    if (filters.maxRent !== undefined)
      conditions.push(lte(rooms.monthly_rent, String(filters.maxRent)));

    const rows = await this.drizzleService.db
      .select({
        id: rooms.id,
        title: rooms.title,
        status: rooms.status,
        areaSqm: rooms.area_sqm,
        monthlyRent: rooms.monthly_rent,
        depositAmount: rooms.deposit_amount,
        propertyId: properties.id,
        propertyName: properties.name,
        address: properties.address,
        ward: properties.ward,
        district: properties.district,
        city: properties.city,
      })
      .from(rooms)
      .innerJoin(properties, eq(rooms.propertyId, properties.id))
      .where(and(...conditions));

    if (rows.length === 0) return [];

    const roomIds = rows.map((r) => r.id);
    const images = await this.drizzleService.db
      .select()
      .from(roomImages)
      .where(inArray(roomImages.roomId, roomIds))
      .orderBy(roomImages.sortOrder);

    const firstImageMap = new Map<string, string>();
    for (const img of images) {
      if (!firstImageMap.has(img.roomId))
        firstImageMap.set(img.roomId, img.url);
    }

    return rows.map(
      (r) =>
        new AvailableRoomEntity(
          r.id,
          r.title,
          r.status as RoomStatus,
          r.areaSqm,
          r.monthlyRent,
          r.depositAmount,
          r.propertyId,
          r.propertyName,
          `${r.address}, ${r.ward}, ${r.district}, ${r.city}`,
          firstImageMap.get(r.id) ?? null,
        ),
    );
  }

  async findDetailById(id: string): Promise<BrowseRoomDetailEntity | null> {
    const [row] = await this.drizzleService.db
      .select({
        room: rooms,
        propertyId: properties.id,
        propertyName: properties.name,
        address: properties.address,
        ward: properties.ward,
        district: properties.district,
        city: properties.city,
        landlordName: users.fullName,
        landlordAvatarUrl: users.avatarUrl,
      })
      .from(rooms)
      .innerJoin(properties, eq(rooms.propertyId, properties.id))
      .innerJoin(users, eq(properties.landlorerId, users.id))
      .where(eq(rooms.id, id));

    if (!row) return null;

    const imgs = await this.drizzleService.db
      .select()
      .from(roomImages)
      .where(eq(roomImages.roomId, id))
      .orderBy(roomImages.sortOrder);

    const { room: r } = row;
    const defaultParkingFees = {
      motorbike: 150000,
      car: 1000000,
    };
    return new BrowseRoomDetailEntity(
      r.id,
      r.title,
      r.status as RoomStatus,
      r.area_sqm,
      r.monthly_rent,
      r.deposit_amount,
      r.electricity_rate_per_kwh,
      r.water_rate_per_m3,
      r.has_furniture,
      r.description ?? null,
      r.included_amenity_codes ?? [],
      (r.addon_amenities as Array<{ code: string; monthly_price: number }>) ??
        [],
      row.propertyId,
      row.propertyName,
      `${row.address}, ${row.ward}, ${row.district}, ${row.city}`,
      row.landlordName,
      row.landlordAvatarUrl ?? null,
      imgs.map((i) => ({ id: i.id, url: i.url, sortOrder: i.sortOrder })),
      (r.parking_fees as { motorbike: number; car: number }) ??
        defaultParkingFees,
    );
  }
}
