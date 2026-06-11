import { DrizzleBrowseRoomRepository } from '../../../src/modules/rooms/infrastructure/drizzle-browse-room.repository';
import { DrizzleService } from '../../../src/shared/infrastructure/database/drizzle.service';

function makeQueryChain(result: any): any {
  const chain = {
    from: jest.fn(() => chain),
    innerJoin: jest.fn(() => chain),
    where: jest.fn(() => chain),
    orderBy: jest.fn(() => chain),
    then: (resolve: any) => resolve(result),
  };
  return chain;
}

describe('DrizzleBrowseRoomRepository', () => {
  let repo: DrizzleBrowseRoomRepository;
  let drizzleService: jest.Mocked<DrizzleService>;

  const roomRow = {
    id: 'room-1',
    title: 'Phong 101',
    status: 'AVAILABLE',
    areaSqm: '25',
    monthlyRent: '3000000',
    depositAmount: '6000000',
    propertyId: 'property-1',
    propertyName: 'Chung cu A',
    address: '123 Le Loi',
    ward: 'Ben Thanh',
    district: 'Quan 1',
    city: 'HCM',
  };

  const detailRow = {
    room: {
      id: 'room-1',
      title: 'Phong 101',
      status: 'AVAILABLE',
      area_sqm: '25',
      monthly_rent: '3000000',
      deposit_amount: '6000000',
      electricity_rate_per_kwh: '3500',
      water_rate_per_m3: '15000',
      has_furniture: false,
      description: null,
      included_amenity_codes: [],
      addon_amenities: [],
      parking_fees: null,
      createdAt: new Date(),
      updatedAt: new Date(),
      propertyId: 'property-1',
      minRent: null,
      maxRent: null,
    },
    propertyId: 'property-1',
    propertyName: 'Chung cu A',
    address: '123 Le Loi',
    ward: 'Ben Thanh',
    district: 'Quan 1',
    city: 'HCM',
    landlordName: 'Nguyen Van A',
    landlordAvatarUrl: null,
  };

  function mockSelectForCalls(results: any[][]) {
    let idx = 0;
    drizzleService.db = {
      select: jest.fn(() => makeQueryChain(results[idx++])),
    } as any;
  }

  beforeEach(() => {
    drizzleService = {} as any;
  });

  describe('findAvailable', () => {
    it('returns available rooms without filters (EP-12)', async () => {
      mockSelectForCalls([[], [roomRow], []]);
      repo = new DrizzleBrowseRoomRepository(drizzleService);

      const result = await repo.findAvailable({});

      expect(result).toHaveLength(1);
      expect(result[0].title).toBe('Phong 101');
    });

    it('filters by minRent (EP-13)', async () => {
      mockSelectForCalls([[], [roomRow], []]);
      repo = new DrizzleBrowseRoomRepository(drizzleService);

      const result = await repo.findAvailable({ minRent: 2000000 });

      expect(result).toHaveLength(1);
    });

    it('filters by maxRent (EP-14)', async () => {
      mockSelectForCalls([[], [roomRow], []]);
      repo = new DrizzleBrowseRoomRepository(drizzleService);

      const result = await repo.findAvailable({ maxRent: 5000000 });

      expect(result).toHaveLength(1);
    });

    it('filters by minRent and maxRent (EP-15)', async () => {
      mockSelectForCalls([[], [roomRow], []]);
      repo = new DrizzleBrowseRoomRepository(drizzleService);

      const result = await repo.findAvailable({ minRent: 2000000, maxRent: 5000000 });

      expect(result).toHaveLength(1);
    });

    it('returns empty when no rooms match', async () => {
      mockSelectForCalls([[], [], []]);
      repo = new DrizzleBrowseRoomRepository(drizzleService);

      const result = await repo.findAvailable({});

      expect(result).toEqual([]);
    });

    it('excludes rooms with sent contracts', async () => {
      mockSelectForCalls([[{ roomId: 'blocked-1' }], [roomRow], []]);
      repo = new DrizzleBrowseRoomRepository(drizzleService);

      const result = await repo.findAvailable({});

      expect(result).toHaveLength(1);
    });
  });

  describe('findDetailById', () => {
    it('returns detail when room exists (ROOM-22)', async () => {
      mockSelectForCalls([[detailRow], []]);
      repo = new DrizzleBrowseRoomRepository(drizzleService);

      const result = await repo.findDetailById('room-1');

      expect(result).not.toBeNull();
      expect(result!.title).toBe('Phong 101');
      expect(result!.landlordName).toBe('Nguyen Van A');
    });

    it('returns null when room not found (ROOM-23)', async () => {
      mockSelectForCalls([[]]);
      repo = new DrizzleBrowseRoomRepository(drizzleService);

      const result = await repo.findDetailById('room-1');

      expect(result).toBeNull();
    });
  });
});
