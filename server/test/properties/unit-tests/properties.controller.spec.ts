import { BadRequestException, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { PropertiesController } from '../../../src/modules/properties/presentation/properties.controller';
import { CreatePropertiesService } from '../../../src/modules/properties/application/services/create-properties.service';
import { GetPropertiesService } from '../../../src/modules/properties/application/services/get-properties.service';
import { GetPropertyByIdService } from '../../../src/modules/properties/application/services/get-property-by-id.service';
import { UpdatePropertiesService } from '../../../src/modules/properties/application/services/update-properties.service';
import { DeletePropertiesService } from '../../../src/modules/properties/application/services/delete-properties.service';
import { CreatePropertiesDto } from '../../../src/modules/properties/application/dto/create-properties.dto';
import { UpdatePropertiesDto } from '../../../src/modules/properties/application/dto/update-properties.dto';
import { PropertiesEntity } from '../../../src/modules/properties/domain/entities/properties.entity';
import { LandlordNotFoundError, PropertiesCannotBeCreatedError } from '../../../src/modules/properties/domain/errors/properties.error';
import { Amenity } from '../../../src/shared/infrastructure/database/enum/amenity';

describe('PropertiesController', () => {
  let controller: PropertiesController;
  let createService: jest.Mocked<CreatePropertiesService>;
  let getPropertiesService: jest.Mocked<GetPropertiesService>;
  let getPropertyByIdService: jest.Mocked<GetPropertyByIdService>;
  let updateService: jest.Mocked<UpdatePropertiesService>;
  let deleteService: jest.Mocked<DeletePropertiesService>;

  const mockUser = { id: 'landlord-1', email: 'test@test.com', phone: null, full_name: 'Landlord', avartar_url: null, roles: ['landlord'] };

  function makeProperty(): PropertiesEntity {
    return new PropertiesEntity(
      'prop-1', 'landlord-1', 'Nha tro Hoa Phuong',
      '12 Nguyen Trai', 'Phuong 5', 'Quan 3', 'TP Ho Chi Minh',
      'Khu tro an ninh', [Amenity.WIFI, Amenity.AIR_CONDITIONER],
      new Date().toISOString(), new Date().toISOString(),
    );
  }

  beforeEach(() => {
    createService = { execute: jest.fn() } as any;
    getPropertiesService = { execute: jest.fn() } as any;
    getPropertyByIdService = { execute: jest.fn() } as any;
    updateService = { execute: jest.fn() } as any;
    deleteService = { execute: jest.fn() } as any;

    controller = new PropertiesController(
      createService,
      getPropertiesService,
      getPropertyByIdService,
      updateService,
      deleteService,
    );
  });

  // --- createProperty ---
  describe('createProperty', () => {
    // PROP-01: Create thành công
    it('creates property and returns with landlored info (PROP-01)', async () => {
      const dto = new CreatePropertiesDto();
      const property = makeProperty();
      createService.execute.mockResolvedValue(property);

      const result = await controller.createProperty(dto, mockUser as any);

      expect(result).toEqual({ ...property, landlored: mockUser });
      expect(createService.execute).toHaveBeenCalledWith({ ...dto, landlorerId: 'landlord-1' });
    });

    // PROP-04: Tenant token (403) — controller không xử lý role, guard làm việc đó
    // Test error mapping

    it('throws BadRequestException on LandlordNotFoundError', async () => {
      createService.execute.mockRejectedValue(new LandlordNotFoundError());

      await expect(
        controller.createProperty(new CreatePropertiesDto(), mockUser as any),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('throws BadRequestException on PropertiesCannotBeCreatedError', async () => {
      createService.execute.mockRejectedValue(new PropertiesCannotBeCreatedError());

      await expect(
        controller.createProperty(new CreatePropertiesDto(), mockUser as any),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('throws InternalServerErrorException on unknown error', async () => {
      createService.execute.mockRejectedValue(new Error('db error'));

      await expect(
        controller.createProperty(new CreatePropertiesDto(), mockUser as any),
      ).rejects.toBeInstanceOf(InternalServerErrorException);
    });
  });

  // --- getProperties ---
  describe('getProperties', () => {
    // PROP-06: Get all properties
    it('returns all properties for current user (PROP-06)', async () => {
      const properties = [makeProperty()];
      getPropertiesService.execute.mockResolvedValue(properties);

      const result = await controller.getProperties(mockUser as any);

      expect(result).toEqual(properties);
      expect(getPropertiesService.execute).toHaveBeenCalledWith('landlord-1');
    });

    it('returns empty array when no properties', async () => {
      getPropertiesService.execute.mockResolvedValue([]);

      const result = await controller.getProperties(mockUser as any);

      expect(result).toEqual([]);
    });
  });

  // --- getPropertyById ---
  describe('getPropertyById', () => {
    // PROP-07: Get by ID thành công
    it('returns property when found (PROP-07)', async () => {
      const property = makeProperty();
      getPropertyByIdService.execute.mockResolvedValue(property);

      const result = await controller.getPropertyById('prop-1', mockUser as any);

      expect(result).toEqual(property);
    });

    // PROP-08: Property không tồn tại
    it('throws NotFoundException when not found (PROP-08)', async () => {
      getPropertyByIdService.execute.mockRejectedValue(new NotFoundException());

      await expect(
        controller.getPropertyById('bad-id', mockUser as any),
      ).rejects.toBeInstanceOf(NotFoundException);
    });

    it('throws InternalServerErrorException on unknown error', async () => {
      getPropertyByIdService.execute.mockRejectedValue(new Error('boom'));

      await expect(
        controller.getPropertyById('prop-1', mockUser as any),
      ).rejects.toBeInstanceOf(InternalServerErrorException);
    });
  });

  // --- updateProperty ---
  describe('updateProperty', () => {
    // PROP-10: Update thành công
    it('updates property successfully (PROP-10)', async () => {
      const dto = new UpdatePropertiesDto();
      dto.name = 'Updated';
      const property = makeProperty();
      updateService.execute.mockResolvedValue(property);

      const result = await controller.updateProperty('prop-1', dto, mockUser as any);

      expect(result).toEqual(property);
      expect(updateService.execute).toHaveBeenCalledWith('prop-1', 'landlord-1', dto);
    });

    // PROP-11: Update không tồn tại
    it('throws NotFoundException when property missing (PROP-11)', async () => {
      updateService.execute.mockRejectedValue(new NotFoundException());

      await expect(
        controller.updateProperty('bad-id', new UpdatePropertiesDto(), mockUser as any),
      ).rejects.toBeInstanceOf(NotFoundException);
    });

    it('throws BadRequestException when input is invalid', async () => {
      updateService.execute.mockRejectedValue(new BadRequestException());

      await expect(
        controller.updateProperty('prop-1', new UpdatePropertiesDto(), mockUser as any),
      ).rejects.toBeInstanceOf(BadRequestException);
    });

    it('throws InternalServerErrorException on unknown error', async () => {
      updateService.execute.mockRejectedValue(new Error('boom'));

      await expect(
        controller.updateProperty('prop-1', new UpdatePropertiesDto(), mockUser as any),
      ).rejects.toBeInstanceOf(InternalServerErrorException);
    });
  });

  // --- deleteProperty ---
  describe('deleteProperty', () => {
    // PROP-13: Delete thành công
    it('deletes property successfully (PROP-13)', async () => {
      deleteService.execute.mockResolvedValue(undefined);

      await expect(
        controller.deleteProperty('prop-1', mockUser as any),
      ).resolves.toBeUndefined();
      expect(deleteService.execute).toHaveBeenCalledWith('prop-1', 'landlord-1');
    });

    // PROP-14: Delete không tồn tại
    it('throws NotFoundException when property missing (PROP-14)', async () => {
      deleteService.execute.mockRejectedValue(new NotFoundException());

      await expect(
        controller.deleteProperty('bad-id', mockUser as any),
      ).rejects.toBeInstanceOf(NotFoundException);
    });

    it('throws InternalServerErrorException on unknown error', async () => {
      deleteService.execute.mockRejectedValue(new Error('boom'));

      await expect(
        controller.deleteProperty('prop-1', mockUser as any),
      ).rejects.toBeInstanceOf(InternalServerErrorException);
    });
  });
});
