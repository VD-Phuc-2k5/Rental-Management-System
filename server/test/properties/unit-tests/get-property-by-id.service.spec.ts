import { NotFoundException } from '@nestjs/common';
import { GetPropertyByIdService } from '../../../src/modules/properties/application/services/get-property-by-id.service';
import { PropertiesRepository } from '../../../src/modules/properties/domain/repositories/properties.repository';
import { PropertiesEntity } from '../../../src/modules/properties/domain/entities/properties.entity';
import { Amenity } from '../../../src/shared/infrastructure/database/enum/amenity';

describe('GetPropertyByIdService', () => {
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
    const service = new GetPropertyByIdService(repository);
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

  // PROP-07: Get property by ID thành công
  it('returns property when found and owned by landlord (PROP-07)', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());

    const result = await service.execute(propertyId, landlordId);

    expect(result.id).toBe(propertyId);
    expect(repository.findById).toHaveBeenCalledWith(propertyId);
  });

  // PROP-08: Property không tồn tại
  it('throws NotFoundException when property does not exist (PROP-08)', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(null);

    await expect(service.execute(propertyId, landlordId)).rejects.toBeInstanceOf(NotFoundException);
  });

  // PROP-09: Property của landlord khác
  it('throws NotFoundException when property belongs to another landlord (PROP-09)', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());

    await expect(service.execute(propertyId, 'other-landlord')).rejects.toBeInstanceOf(NotFoundException);
  });

  it('throws NotFoundException with correct Vietnamese message', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(null);

    let error: NotFoundException | undefined;
    try { await service.execute(propertyId, landlordId); } catch (e) { error = e as NotFoundException; }
    expect(error!.message).toBe('Khu tro khong ton tai');
  });
});
