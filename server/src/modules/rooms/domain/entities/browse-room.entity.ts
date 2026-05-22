import { RoomAddonAmenity, RoomStatus } from './room.entity';

export class AvailableRoomEntity {
  constructor(
    public readonly id: string,
    public readonly title: string,
    public readonly status: RoomStatus,
    public readonly areaSqm: string,
    public readonly monthlyRent: string,
    public readonly depositAmount: string,
    public readonly propertyId: string,
    public readonly propertyName: string,
    public readonly fullAddress: string,
    public readonly firstImageUrl: string | null,
  ) {}
}

export class BrowseRoomDetailEntity {
  constructor(
    public readonly id: string,
    public readonly title: string,
    public readonly status: RoomStatus,
    public readonly areaSqm: string,
    public readonly monthlyRent: string,
    public readonly depositAmount: string,
    public readonly electricityRatePerKwh: string,
    public readonly waterRatePerM3: string,
    public readonly hasFurniture: boolean,
    public readonly description: string | null,
    public readonly includedAmenityCodes: string[],
    public readonly addonAmenities: RoomAddonAmenity[],
    public readonly propertyId: string,
    public readonly propertyName: string,
    public readonly fullAddress: string,
    public readonly landlordName: string,
    public readonly landlordAvatarUrl: string | null,
    public readonly images: Array<{ id: string; url: string; sortOrder: number }>,
  ) {}
}
