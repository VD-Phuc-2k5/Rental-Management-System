export type RoomStatus = 'AVAILABLE' | 'OCCUPIED' | 'MAINTENANCE';

export type RoomAddonAmenity = { code: string; monthly_price: number };

export type RoomImage = { id: string; url: string; sortOrder: number };

export class RoomEntity {
  constructor(
    public readonly id: string,
    public readonly propertyId: string,
    public readonly title: string,
    public readonly status: RoomStatus,
    public readonly area_sqm: string,
    public readonly monthly_rent: string,
    public readonly deposit_amount: string,
    public readonly electricity_rate_per_kwh: string,
    public readonly water_rate_per_m3: string,
    public readonly has_furniture: boolean,
    public readonly description: string | null,
    public readonly included_amenity_codes: string[],
    public readonly addon_amenities: RoomAddonAmenity[],
    public readonly createdAt: string,
    public readonly updatedAt: string,
    public readonly images: RoomImage[] = [],
  ) {}
}
