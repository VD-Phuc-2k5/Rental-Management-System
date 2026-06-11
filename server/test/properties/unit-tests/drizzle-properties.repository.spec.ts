import { DrizzlePropertiesRepository } from '../../../src/modules/properties/infrastructure/drizzle-properties.repository';
import { DrizzleService } from '../../../src/shared/infrastructure/database/drizzle.service';
import { LandlordNotFoundError } from '../../../src/modules/properties/domain/errors/properties.error';
import { Amenity } from '../../../src/shared/infrastructure/database/enum/amenity';

function makeTerminalChain<T>(result: T) {
  const chain: any = {
    where: jest.fn(() => chain),
    returning: jest.fn(() => chain),
    then: (resolve: (v: T) => any) => resolve(result),
  };
  return chain;
}

function makeInsertChain<T>(result: T) {
  const terminal = makeTerminalChain(result);
  return { values: jest.fn(() => terminal) };
}

function makeSelectChain<T>(result: T) {
  const inner = makeTerminalChain(result);
  return { from: jest.fn(() => inner) };
}

function makeUpdateChain<T>(result: T) {
  const terminal = makeTerminalChain(result);
  const afterWhere = { returning: jest.fn(() => terminal) };
  return { set: jest.fn(() => ({ where: jest.fn(() => afterWhere) })) };
}

function makeDeleteChain() {
  const terminal = makeTerminalChain(undefined);
  return { where: jest.fn(() => terminal) };
}

function buildDb(overrides?: Partial<Record<'insert' | 'select' | 'update' | 'delete', jest.Mock>>) {
  return {
    insert: overrides?.insert ?? jest.fn(),
    select: overrides?.select ?? jest.fn(),
    update: overrides?.update ?? jest.fn(),
    delete: overrides?.delete ?? jest.fn(),
  } as any;
}

describe('DrizzlePropertiesRepository', () => {
  let repo: DrizzlePropertiesRepository;
  let drizzleService: jest.Mocked<DrizzleService>;

  const now = new Date();
  const propertyRow = {
    id: 'prop-1',
    landlorerId: 'landlord-1',
    name: 'Nha tro Hoa Phuong',
    address: '12 Nguyen Trai',
    ward: 'Phuong 5',
    district: 'Quan 3',
    city: 'TP Ho Chi Minh',
    description: 'Khu tro an ninh',
    amenity_codes: ['WIFI', 'AIR_CONDITIONER'],
    createdAt: now,
    updatedAt: now,
  };

  beforeEach(() => {
    drizzleService = { schema: {} as any } as any;
  });

  describe('createProperty', () => {
    it('creates a property successfully', async () => {
      drizzleService.db = buildDb({ insert: () => makeInsertChain([propertyRow]) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      const result = await repo.createProperty({
        landlorerId: 'landlord-1',
        name: 'Nha tro Hoa Phuong',
        address: '12 Nguyen Trai',
        ward: 'Phuong 5',
        district: 'Quan 3',
        city: 'TP Ho Chi Minh',
        description: 'Khu tro an ninh',
        amenityCodes: [Amenity.WIFI, Amenity.AIR_CONDITIONER],
      });

      expect(result.id).toBe('prop-1');
      expect(result.name).toBe('Nha tro Hoa Phuong');
      expect(result.amenityCodes).toEqual(['WIFI', 'AIR_CONDITIONER']);
    });

    it('throws LandlordNotFoundError on foreign key violation (code 23503)', async () => {
      const error = Object.assign(new Error('foreign key violation'), { code: '23503' });
      const terminal = {
        returning: jest.fn(() => terminal),
        then: jest.fn(() => { throw error; }),
      };
      drizzleService.db = buildDb({ insert: () => ({ values: jest.fn(() => terminal) }) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      await expect(repo.createProperty({
        landlorerId: 'bad-id', name: 'Test', address: 'Addr', ward: 'Ward',
        district: 'Dist', city: 'City', description: 'Desc', amenityCodes: [Amenity.WIFI],
      })).rejects.toBeInstanceOf(LandlordNotFoundError);
    });

    it('throws original error on non-foreign-key error', async () => {
      const error = new Error('unique constraint violation');
      (error as any).code = '23505';
      const terminal = {
        returning: jest.fn(() => terminal),
        then: jest.fn(() => { throw error; }),
      };
      drizzleService.db = buildDb({ insert: () => ({ values: jest.fn(() => terminal) }) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      await expect(repo.createProperty({
        landlorerId: 'bad-id', name: 'Test', address: 'Addr', ward: 'Ward',
        district: 'Dist', city: 'City', description: 'Desc', amenityCodes: [Amenity.WIFI],
      })).rejects.toThrow('unique constraint violation');
    });
  });

  describe('findAllByLandlordId', () => {
    it('returns properties for a landlord', async () => {
      drizzleService.db = buildDb({ select: () => makeSelectChain([propertyRow]) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      const result = await repo.findAllByLandlordId('landlord-1');

      expect(result).toHaveLength(1);
      expect(result[0].name).toBe('Nha tro Hoa Phuong');
    });

    it('returns empty array when no properties', async () => {
      drizzleService.db = buildDb({ select: () => makeSelectChain([]) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      const result = await repo.findAllByLandlordId('landlord-1');

      expect(result).toEqual([]);
    });
  });

  describe('findById', () => {
    it('returns property when found', async () => {
      drizzleService.db = buildDb({ select: () => makeSelectChain([propertyRow]) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      const result = await repo.findById('prop-1');

      expect(result).not.toBeNull();
      expect(result!.id).toBe('prop-1');
    });

    it('returns null when not found', async () => {
      drizzleService.db = buildDb({ select: () => makeSelectChain([]) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      const result = await repo.findById('prop-1');

      expect(result).toBeNull();
    });

    it('throws error when row has invalid amenity codes (toAmenityCodes safety net)', async () => {
      const badRow = { ...propertyRow, amenity_codes: ['INVALID_AMENITY'] };
      drizzleService.db = buildDb({ select: () => makeSelectChain([badRow]) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      await expect(repo.findById('prop-1')).rejects.toThrow('Invalid amenity codes');
    });
  });

  describe('updateProperty', () => {
    it('updates property fields', async () => {
      drizzleService.db = buildDb({ update: () => makeUpdateChain([propertyRow]) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      const result = await repo.updateProperty('prop-1', 'landlord-1', { name: 'Updated Name' });

      expect(result.id).toBe('prop-1');
    });

    it('updates with multiple fields', async () => {
      drizzleService.db = buildDb({ update: () => makeUpdateChain([propertyRow]) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      const result = await repo.updateProperty('prop-1', 'landlord-1', {
        name: 'New',
        description: 'New desc',
        amenityCodes: [Amenity.WIFI],
      });

      expect(result.id).toBe('prop-1');
    });

    it('updates all fields', async () => {
      drizzleService.db = buildDb({ update: () => makeUpdateChain([propertyRow]) });
      repo = new DrizzlePropertiesRepository(drizzleService);

      const result = await repo.updateProperty('prop-1', 'landlord-1', {
        name: 'New', address: 'New Addr', ward: 'New Ward',
        district: 'New Dist', city: 'New City', description: 'New Desc',
        amenityCodes: [Amenity.WIFI],
      });

      expect(result.id).toBe('prop-1');
    });
  });

  describe('deleteProperty', () => {
    it('deletes property by id and landlordId', async () => {
      drizzleService.db = buildDb({ delete: () => makeDeleteChain() });
      repo = new DrizzlePropertiesRepository(drizzleService);

      await repo.deleteProperty('prop-1', 'landlord-1');
    });
  });
});
