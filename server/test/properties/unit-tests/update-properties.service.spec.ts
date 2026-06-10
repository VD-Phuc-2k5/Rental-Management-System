import { BadRequestException, NotFoundException } from '@nestjs/common';
import { UpdatePropertiesService } from '../../../src/modules/properties/application/services/update-properties.service';
import { PropertiesRepository } from '../../../src/modules/properties/domain/repositories/properties.repository';
import { UpdatePropertiesDto } from '../../../src/modules/properties/application/dto/update-properties.dto';
import { PropertiesEntity } from '../../../src/modules/properties/domain/entities/properties.entity';
import { Amenity } from '../../../src/shared/infrastructure/database/enum/amenity';

describe('UpdatePropertiesService', () => {
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
    const service = new UpdatePropertiesService(repository);
    return { service, repository };
  }

  function makeEntity(): PropertiesEntity {
    return new PropertiesEntity(
      propertyId, landlordId, 'Nha tro Hoa Phuong',
      '12 Nguyen Trai', 'Phuong 5', 'Quan 3', 'TP Ho Chi Minh',
      'Khu tro an ninh', [Amenity.WIFI, Amenity.AIR_CONDITIONER],
      new Date().toISOString(), new Date().toISOString(),
    );
  }

  function updateDto(): UpdatePropertiesDto {
    return Object.assign(new UpdatePropertiesDto(), {
      name: 'Updated Name',
      description: 'Updated description',
    });
  }

  // PROP-10: Update property thành công
  it('updates property successfully (PROP-10)', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());
    repository.updateProperty.mockResolvedValue({ ...makeEntity(), name: 'Updated Name' });

    const result = await service.execute(propertyId, landlordId, updateDto());

    expect(result.name).toBe('Updated Name');
    expect(repository.updateProperty).toHaveBeenCalledWith(propertyId, landlordId, updateDto());
  });

  // PROP-11: Update property không tồn tại
  it('throws NotFoundException when property does not exist (PROP-11)', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(null);

    await expect(service.execute(propertyId, landlordId, updateDto())).rejects.toBeInstanceOf(NotFoundException);
  });

  // PROP-12: Update property của landlord khác
  it('throws NotFoundException when property belongs to another landlord (PROP-12)', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());

    await expect(service.execute(propertyId, 'other-landlord', updateDto())).rejects.toBeInstanceOf(NotFoundException);
  });

  // amenityCodes không hợp lệ khi update
  it('throws BadRequestException when updating with invalid amenityCodes', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());
    const input = updateDto();
    input.amenityCodes = ['INVALID'] as Amenity[];

    await expect(service.execute(propertyId, landlordId, input)).rejects.toBeInstanceOf(BadRequestException);
  });

  // amenityCodes hợp lệ khi update
  it('accepts valid amenityCodes when updating', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());
    repository.updateProperty.mockResolvedValue(makeEntity());
    const input = updateDto();
    input.amenityCodes = [Amenity.WIFI, Amenity.BED];

    const result = await service.execute(propertyId, landlordId, input);

    expect(result).toBeDefined();
    expect(repository.updateProperty).toHaveBeenCalledWith(propertyId, landlordId, input);
  });

  // update với input rỗng (chỉ gửi các field cần update)
  it('updates with partial fields', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());
    repository.updateProperty.mockResolvedValue(makeEntity());
    const input = new UpdatePropertiesDto();
    input.name = 'Just name update';

    const result = await service.execute(propertyId, landlordId, input);

    expect(result).toBeDefined();
    expect(repository.updateProperty).toHaveBeenCalledWith(propertyId, landlordId, input);
  });

  // repository update thất bại
  it('propagates error when repository update fails', async () => {
    const { service, repository } = createService();
    repository.findById.mockResolvedValue(makeEntity());
    repository.updateProperty.mockRejectedValue(new Error('update failed'));

    await expect(service.execute(propertyId, landlordId, updateDto())).rejects.toThrow('update failed');
  });
});
