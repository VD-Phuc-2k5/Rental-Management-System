import { DrizzleRoomRepository } from '../../../src/modules/rooms/infrastructure/drizzle-room.repository';
import { DrizzleService } from '../../../src/shared/infrastructure/database/drizzle.service';

function makeTerminalChain(result: any) {
  const chain = {
    where: jest.fn(() => chain),
    orderBy: jest.fn(() => chain),
    returning: jest.fn(() => chain),
    then: (resolve: any) => resolve(result),
  };
  return chain;
}

function makeSelectChain(result: any) {
  const inner = makeTerminalChain(result);
  const outer = {
    from: jest.fn(() => inner),
  };
  return outer;
}

function makeUpdateChain(result: any) {
  const terminal = makeTerminalChain(result);
  const where = { returning: jest.fn(() => terminal) };
  const afterSet = { where: jest.fn(() => where) };
  const chain = { set: jest.fn(() => afterSet) };
  return chain;
}

function makeInsertChain(result: any) {
  const terminal = makeTerminalChain(result);
  return { values: jest.fn(() => terminal) };
}

function makeDeleteChain() {
  const terminal = makeTerminalChain(undefined);
  return { where: jest.fn(() => terminal) };
}

describe('DrizzleRoomRepository', () => {
  let repo: DrizzleRoomRepository;
  let drizzleService: jest.Mocked<DrizzleService>;

  const now = new Date();
  const roomRow = {
    id: 'room-1',
    propertyId: 'property-1',
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
    createdAt: now,
    updatedAt: now,
    minRent: null,
    maxRent: null,
  };

  const imgRow = { id: 'img-1', url: 'https://example.com/img.jpg', sortOrder: 0, roomId: 'room-1' };

  function buildDb(overrides?: Partial<Record<'insert' | 'select' | 'update' | 'delete', () => any>>) {
    return {
      insert: overrides?.insert ?? jest.fn(),
      select: overrides?.select ?? jest.fn(),
      update: overrides?.update ?? jest.fn(),
      delete: overrides?.delete ?? jest.fn(),
    } as any;
  }

  beforeEach(() => {
    drizzleService = { schema: {} as any } as any;
  });

  describe('createRoom', () => {
    it('creates a room without images', async () => {
      drizzleService.db = buildDb({ insert: () => makeInsertChain([roomRow]) });
      repo = new DrizzleRoomRepository(drizzleService);

      const result = await repo.createRoom({
        propertyId: 'property-1', title: 'Phong 101',
        area_sqm: 25, monthly_rent: 3000000, deposit_amount: 6000000,
        electricity_rate_per_kwh: 3500, water_rate_per_m3: 15000,
      });

      expect(result.id).toBe('room-1');
    });

    it('creates a room with images', async () => {
      const insert = jest.fn()
        .mockReturnValueOnce(makeInsertChain([roomRow]))
        .mockReturnValueOnce(makeInsertChain([imgRow]));
      drizzleService.db = buildDb({ insert });
      repo = new DrizzleRoomRepository(drizzleService);

      const result = await repo.createRoom({
        propertyId: 'property-1', title: 'Phong 101',
        area_sqm: 25, monthly_rent: 3000000, deposit_amount: 6000000,
        electricity_rate_per_kwh: 3500, water_rate_per_m3: 15000,
        images: [{ url: 'https://example.com/img.jpg' }],
      });

      expect(result.images).toHaveLength(1);
    });
  });

  describe('findAllByPropertyId', () => {
    it('returns rooms for a property', async () => {
      const select = jest.fn()
        .mockReturnValueOnce(makeSelectChain([roomRow]))
        .mockReturnValueOnce(makeSelectChain([]));
      drizzleService.db = buildDb({ select });
      repo = new DrizzleRoomRepository(drizzleService);

      const result = await repo.findAllByPropertyId('property-1');

      expect(result).toHaveLength(1);
      expect(result[0].title).toBe('Phong 101');
    });

    it('returns empty array when no rooms', async () => {
      drizzleService.db = buildDb({ select: () => makeSelectChain([]) });
      repo = new DrizzleRoomRepository(drizzleService);

      const result = await repo.findAllByPropertyId('property-1');

      expect(result).toEqual([]);
    });
  });

  describe('findById', () => {
    it('returns room when found', async () => {
      const select = jest.fn()
        .mockReturnValueOnce(makeSelectChain([roomRow]))
        .mockReturnValueOnce(makeSelectChain([]));
      drizzleService.db = buildDb({ select });
      repo = new DrizzleRoomRepository(drizzleService);

      const result = await repo.findById('room-1');

      expect(result).not.toBeNull();
      expect(result!.id).toBe('room-1');
    });

    it('returns null when not found', async () => {
      drizzleService.db = buildDb({ select: () => makeSelectChain([]) });
      repo = new DrizzleRoomRepository(drizzleService);

      const result = await repo.findById('room-1');

      expect(result).toBeNull();
    });
  });

  describe('updateRoom', () => {
    it('updates room fields without changing images', async () => {
      drizzleService.db = buildDb({
        update: () => makeUpdateChain([roomRow]),
        select: () => makeSelectChain([imgRow]),
      });
      repo = new DrizzleRoomRepository(drizzleService);

      const result = await repo.updateRoom('room-1', { title: 'Updated' });

      expect(result.id).toBe('room-1');
    });

    it('updates with replacing images', async () => {
      const insert = jest.fn()
        .mockReturnValueOnce(makeInsertChain([roomRow]))
        .mockReturnValueOnce(makeInsertChain([imgRow]));
      drizzleService.db = buildDb({
        update: () => makeUpdateChain([roomRow]),
        insert,
        delete: () => makeDeleteChain(),
      });
      repo = new DrizzleRoomRepository(drizzleService);

      const result = await repo.updateRoom('room-1', {
        title: 'Updated',
        images: [{ url: 'https://example.com/new.jpg' }],
      });

      expect(result.id).toBe('room-1');
    });

    it('keeps existing images when images not in update input', async () => {
      drizzleService.db = buildDb({
        update: () => makeUpdateChain([roomRow]),
        select: () => makeSelectChain([imgRow]),
      });
      repo = new DrizzleRoomRepository(drizzleService);

      const result = await repo.updateRoom('room-1', { title: 'Updated' });

      expect(result.id).toBe('room-1');
    });
  });

  describe('deleteRoom', () => {
    it('deletes room by id', async () => {
      drizzleService.db = buildDb({ delete: () => makeDeleteChain() });
      repo = new DrizzleRoomRepository(drizzleService);

      await repo.deleteRoom('room-1');
    });
  });
});
