import { NotFoundException } from '@nestjs/common';
import { DeletePropertiesService } from '../../../src/modules/properties/application/services/delete-properties.service';
import { PropertiesRepository } from '../../../src/modules/properties/domain/repositories/properties.repository';
import { PropertiesEntity } from '../../../src/modules/properties/domain/entities/properties.entity';
import { Amenity } from '../../../src/shared/infrastructure/database/enum/amenity';

describe('DeletePropertiesService', () => {
  const landlordId = 'landlord-1';
  const propertyId = 'prop-1';

  function createService() {
    const repository: jest.Mocked<PropertiesRepository> = {
      createProperty: jest.fn(),
      findAllByLandlordId: jest.fn(),
      findById: jest.fn(),
      updateProperty: jest.fn(),
      deleteProperty: jest.fn(),
    };
    const service = new DeletePropertiesService(repository);
    return { service, repository };
  }

  function makeEntity(): PropertiesEntity {
    return new PropertiesEntity(
      propertyId, landlordId, 'Nha tro Hoa Phuong',
      '12 Nguyen Trai', 'Phuong 5', 'Quan 3', 'TP Ho Chi Minh',
      'Khu tro an ninh', [Amenity.WIFI],
      new Date().toISOString(), new Date().toISOString(),
    );
  }

  // PROP-13: Delete property thành công
  it('deletes property successfully (PROP-13)', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());
    repository.deleteProperty.mockResolvedValue(undefined);

    await service.execute(propertyId, landlordId);

    expect(repository.deleteProperty).toHaveBeenCalledWith(propertyId, landlordId);
  });

  // PROP-14: Delete property không tồn tại
  it('throws NotFoundException when property does not exist (PROP-14)', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(null);

    await expect(service.execute(propertyId, landlordId)).rejects.toBeInstanceOf(NotFoundException);
    expect(repository.deleteProperty).not.toHaveBeenCalled();
  });

  // PROP-15: Delete property của landlord khác
  it('throws NotFoundException when property belongs to another landlord (PROP-15)', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());

    await expect(service.execute(propertyId, 'other-landlord')).rejects.toBeInstanceOf(NotFoundException);
    expect(repository.deleteProperty).not.toHaveBeenCalled();
  });

  // repository delete thất bại
  it('propagates error when repository delete fails', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());
    repository.deleteProperty.mockRejectedValue(new Error('delete failed'));

    await expect(service.execute(propertyId, landlordId)).rejects.toThrow('delete failed');
  });
});
