import { GetPropertiesService } from '../../../src/modules/properties/application/services/get-properties.service';
import { PropertiesRepository } from '../../../src/modules/properties/domain/repositories/properties.repository';
import { PropertiesEntity } from '../../../src/modules/properties/domain/entities/properties.entity';
import { Amenity } from '../../../src/shared/infrastructure/database/enum/amenity';

describe('GetPropertiesService', () => {
  function createService() {
    const repository: jest.Mocked<PropertiesRepository> = {
      createProperty: jest.fn(),
      findAllByLandlordId: jest.fn(),
      findById: jest.fn(),
      updateProperty: jest.fn(),
      deleteProperty: jest.fn(),
    };
    const service = new GetPropertiesService(repository);
    return { service, repository };
  }

  function makeEntity(): PropertiesEntity {
    return new PropertiesEntity(
      'prop-1', 'landlord-1', 'Nha tro Hoa Phuong',
      '12 Nguyen Trai', 'Phuong 5', 'Quan 3', 'TP Ho Chi Minh',
      'Khu tro an ninh', [Amenity.WIFI],
      new Date().toISOString(), new Date().toISOString(),
    );
  }

  // PROP-06: Get all properties của landlord
  it('returns all properties for given landlord (EP valid)', async () => {
    const { service, repository } = createService();
    const properties = [makeEntity(), { ...makeEntity(), id: 'prop-2' }];
    repository.findAllByLandlordId.mockResolvedValue(properties as PropertiesEntity[]);

    const result = await service.execute('landlord-1');

    expect(result).toHaveLength(2);
    expect(repository.findAllByLandlordId).toHaveBeenCalledWith('landlord-1');
  });

  it('returns empty array when landlord has no properties', async () => {
    const { service, repository } = createService();
    repository.findAllByLandlordId.mockResolvedValue([]);

    const result = await service.execute('landlord-1');

    expect(result).toEqual([]);
  });

  it('passes correct landlordId to repository', async () => {
    const { service, repository } = createService();
    repository.findAllByLandlordId.mockResolvedValue([]);

    await service.execute('some-landlord-id');

    expect(repository.findAllByLandlordId).toHaveBeenCalledWith('some-landlord-id');
  });
});
