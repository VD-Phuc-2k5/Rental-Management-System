import { BadRequestException } from '@nestjs/common';
import { CreatePropertiesService } from '../../../src/modules/properties/application/services/create-properties.service';
import { PropertiesRepository } from '../../../src/modules/properties/domain/repositories/properties.repository';
import { CreatePropertiesDto } from '../../../src/modules/properties/application/dto/create-properties.dto';
import { PropertiesEntity } from '../../../src/modules/properties/domain/entities/properties.entity';
import { Amenity } from '../../../src/shared/infrastructure/database/enum/amenity';

describe('CreatePropertiesService', () => {
  const landlordId = 'landlord-1';

  function createService() {
    const repository: jest.Mocked<PropertiesRepository> = {
      createProperty: jest.fn(),
      findAllByLandlordId: jest.fn(),
      findById: jest.fn(),
      updateProperty: jest.fn(),
      deleteProperty: jest.fn(),
    };
    const service = new CreatePropertiesService(repository);
    return { service, repository };
  }

  function makeEntity(): PropertiesEntity {
    return new PropertiesEntity(
      'prop-1',
      landlordId,
      'Nha tro Hoa Phuong',
      '12 Nguyen Trai',
      'Phuong 5',
      'Quan 3',
      'TP Ho Chi Minh',
      'Khu tro an ninh',
      [Amenity.WIFI, Amenity.AIR_CONDITIONER],
      new Date().toISOString(),
      new Date().toISOString(),
    );
  }

  function validInput(): CreatePropertiesDto {
    return Object.assign(new CreatePropertiesDto(), {
      landlorerId: landlordId,
      name: 'Nha tro Hoa Phuong',
      address: '12 Nguyen Trai',
      ward: 'Phuong 5',
      district: 'Quan 3',
      city: 'TP Ho Chi Minh',
      description: 'Khu tro an ninh',
      amenityCodes: [Amenity.WIFI, Amenity.AIR_CONDITIONER],
    });
  }

  // PROP-01: Create property thành công
  it('creates property successfully with valid data (EP-01, EP-03, EP-05, EP-06, EP-07, EP-08, EP-09)', async () => {
    const { service, repository } = createService();
    repository.createProperty.mockResolvedValue(makeEntity());

    const result = await service.execute(validInput());

    expect(result.id).toBe('prop-1');
    expect(result.name).toBe('Nha tro Hoa Phuong');
    expect(repository.createProperty).toHaveBeenCalledWith({
      landlorerId: landlordId,
      name: 'Nha tro Hoa Phuong',
      address: '12 Nguyen Trai',
      ward: 'Phuong 5',
      district: 'Quan 3',
      city: 'TP Ho Chi Minh',
      description: 'Khu tro an ninh',
      amenityCodes: [Amenity.WIFI, Amenity.AIR_CONDITIONER],
    });
  });

  // EP-10: amenityCodes chứa giá trị không hợp lệ
  it('throws BadRequestException when amenityCodes contain invalid values (EP-10)', async () => {
    const { service } = createService();
    const input = validInput();
    input.amenityCodes = ['INVALID_AMENITY'] as unknown as Amenity[];

    await expect(service.execute(input)).rejects.toBeInstanceOf(BadRequestException);
  });

  // EP-10: nhiều amenity codes không hợp lệ
  it('throws BadRequestException with all invalid amenity codes listed', async () => {
    const { service } = createService();
    const input = validInput();
    input.amenityCodes = ['FAKE1', 'FAKE2'] as unknown as Amenity[];

    let error: BadRequestException | undefined;
    try { await service.execute(input); } catch (e) { error = e as BadRequestException; }
    expect(error).toBeDefined();
    expect(error!.message).toContain('FAKE1');
    expect(error!.message).toContain('FAKE2');
  });

  // EP-11: amenityCodes rỗng — DTO validation (@IsNotEmpty()) catches this,
  // service layer passes empty array to repository (no invalid codes to filter)
  it('passes empty amenityCodes to repository (EP-11 caught by DTO)', async () => {
    const { service, repository } = createService();
    repository.createProperty.mockResolvedValue(makeEntity());
    const input = validInput();
    input.amenityCodes = [];

    const result = await service.execute(input);

    expect(result).toBeDefined();
    expect(repository.createProperty).toHaveBeenCalledWith(
      expect.objectContaining({ amenityCodes: [] }),
    );
  });

  // repository trả về lỗi
  it('propagates repository error when creation fails', async () => {
    const { service, repository } = createService();
    repository.createProperty.mockRejectedValue(new Error('db error'));

    await expect(service.execute(validInput())).rejects.toThrow('db error');
  });
});
