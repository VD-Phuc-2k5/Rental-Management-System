import { PropertiesEntity } from '../../../src/modules/properties/domain/entities/properties.entity';
import { Amenity } from '../../../src/shared/infrastructure/database/enum/amenity';

describe('PropertiesEntity', () => {
  const now = new Date().toISOString();
  const validAmenities: Amenity[] = [Amenity.WIFI, Amenity.AIR_CONDITIONER, Amenity.PARKING];

  function makeEntity(amenities: Amenity[] = validAmenities): PropertiesEntity {
    return new PropertiesEntity(
      'prop-1',
      'landlord-1',
      'Nha tro Hoa Phuong',
      '12 Nguyen Trai',
      'Phuong 5',
      'Quan 3',
      'TP Ho Chi Minh',
      'Khu tro an ninh',
      amenities,
      now,
      now,
    );
  }

  it('creates entity with all properties', () => {
    const entity = makeEntity();
    expect(entity.id).toBe('prop-1');
    expect(entity.landlorerId).toBe('landlord-1');
    expect(entity.name).toBe('Nha tro Hoa Phuong');
    expect(entity.address).toBe('12 Nguyen Trai');
    expect(entity.ward).toBe('Phuong 5');
    expect(entity.district).toBe('Quan 3');
    expect(entity.city).toBe('TP Ho Chi Minh');
    expect(entity.description).toBe('Khu tro an ninh');
    expect(entity.amenityCodes).toEqual([Amenity.WIFI, Amenity.AIR_CONDITIONER, Amenity.PARKING]);
    expect(entity.createdAt).toBe(now);
    expect(entity.updatedAt).toBe(now);
  });

  describe('isValidAmenity', () => {
    it('returns true when amenity is in the list', () => {
      const entity = makeEntity();
      expect(entity.isValidAmenity(Amenity.WIFI)).toBe(true);
      expect(entity.isValidAmenity(Amenity.AIR_CONDITIONER)).toBe(true);
    });

    it('returns false when amenity is not in the list', () => {
      const entity = makeEntity([Amenity.WIFI]);
      expect(entity.isValidAmenity(Amenity.BED)).toBe(false);
      expect(entity.isValidAmenity(Amenity.FRIDGE)).toBe(false);
    });

    it('returns false for empty amenity list', () => {
      const entity = makeEntity([]);
      expect(entity.isValidAmenity(Amenity.WIFI)).toBe(false);
    });
  });
});
