import { NotFoundException } from '@nestjs/common';
import { CreateRoomService } from '../../../src/modules/rooms/application/services/create-room.service';
import { RoomRepository } from '../../../src/modules/rooms/domain/repositories/room.repository';
import { PropertiesRepository } from '../../../src/modules/properties/domain/repositories/properties.repository';
import { CreateRoomDto } from '../../../src/modules/rooms/application/dto/create-room.dto';
import { RoomEntity } from '../../../src/modules/rooms/domain/entities/room.entity';
import { PropertiesEntity } from '../../../src/modules/properties/domain/entities/properties.entity';

describe('CreateRoomService', () => {
  const propertyId = 'property-1';
  const landlordId = 'landlord-1';

  function createService() {
    const roomRepository: jest.Mocked<RoomRepository> = {
      createRoom: jest.fn(),
      findAllByPropertyId: jest.fn(),
      findById: jest.fn(),
      updateRoom: jest.fn(),
      deleteRoom: jest.fn(),
    };

    const propertiesRepository: jest.Mocked<PropertiesRepository> = {
      createProperty: jest.fn(),
      findAllByLandlordId: jest.fn(),
      findById: jest.fn(),
      updateProperty: jest.fn(),
      deleteProperty: jest.fn(),
    };

    const service = new CreateRoomService(roomRepository, propertiesRepository);
    return { service, roomRepository, propertiesRepository };
  }

  function makeProperty(): PropertiesEntity {
    return new PropertiesEntity(
      propertyId,
      landlordId,
      'Chung cu A',
      '123 Le Loi',
      'Phuong Ben Thanh',
      'Quan 1',
      'HCM',
      'Mo ta',
      [],
      new Date().toISOString(),
      new Date().toISOString(),
    );
  }

  function makeRoom(): RoomEntity {
    return new RoomEntity(
      'room-1',
      propertyId,
      'Phong 101',
      'AVAILABLE',
      '25',
      '3000000',
      '6000000',
      '3500',
      '15000',
      false,
      null,
      [],
      [],
      new Date().toISOString(),
      new Date().toISOString(),
    );
  }

  function validDto(): CreateRoomDto {
    return Object.assign(new CreateRoomDto(), {
      title: 'Phong 101',
      area_sqm: 25,
      monthly_rent: 3000000,
      deposit_amount: 6000000,
      electricity_rate_per_kwh: 3500,
      water_rate_per_m3: 15000,
    });
  }

  // ROOM-01: Create room thành công (đầy đủ) — EP
  it('creates room successfully with valid data (EP-01, EP-03, EP-05, EP-07, EP-08)', async () => {
    const { service, roomRepository, propertiesRepository } = createService();
    propertiesRepository.findById.mockResolvedValue(makeProperty());
    roomRepository.createRoom.mockResolvedValue(makeRoom());

    const result = await service.execute(propertyId, landlordId, validDto());

    expect(result.id).toBe('room-1');
    expect(result.title).toBe('Phong 101');
    expect(roomRepository.createRoom).toHaveBeenCalled();
  });

  // ROOM-01b: Create room với tất cả optional fields
  it('creates room successfully with all optional fields', async () => {
    const { service, roomRepository, propertiesRepository } = createService();
    propertiesRepository.findById.mockResolvedValue(makeProperty());
    const fullDto = Object.assign(new CreateRoomDto(), {
      title: 'Phong 102',
      area_sqm: 30,
      monthly_rent: 3500000,
      deposit_amount: 7000000,
      electricity_rate_per_kwh: 3500,
      water_rate_per_m3: 15000,
      has_furniture: true,
      description: 'Phong sang, thoang mat',
      included_amenity_codes: ['AC', 'BED'],
      addon_amenities: [{ code: 'TV', monthly_price: 50000 }],
      parking_fees: { motorbike: 150000, car: 1000000 },
      images: [{ url: 'https://storage.example.com/rooms/img.jpg', sortOrder: 0 }],
    });
    const createdRoom = makeRoom();
    roomRepository.createRoom.mockResolvedValue(createdRoom);

    const result = await service.execute(propertyId, landlordId, fullDto);

    expect(result).toBeDefined();
    expect(roomRepository.createRoom).toHaveBeenCalledWith({
      propertyId,
      ...fullDto,
    });
  });

  // ROOM-02: Create room với property không tồn tại
  it('throws NotFoundException when property does not exist', async () => {
    const { service, propertiesRepository } = createService();
    propertiesRepository.findById.mockResolvedValue(null);

    await expect(
      service.execute(propertyId, landlordId, validDto()),
    ).rejects.toBeInstanceOf(NotFoundException);
  });

  // ROOM-08: Create room với landlord không sở hữu property
  it('throws NotFoundException when landlord does not own property', async () => {
    const { service, propertiesRepository } = createService();
    const property = makeProperty();
    propertiesRepository.findById.mockResolvedValue(property);

    await expect(
      service.execute(propertyId, 'other-landlord', validDto()),
    ).rejects.toBeInstanceOf(NotFoundException);
  });

  // BUG: service phải reject monthly_rent = 0 (BVA-03 / ROOM-05)
  // Cần sửa DTO: @Min(1) thay vì @Min(0)
  it('[BUG] BVA-03 / ROOM-05: monthly_rent = 0 should reject → actually accepted', async () => {
    const { service, roomRepository, propertiesRepository } = createService();
    propertiesRepository.findById.mockResolvedValue(makeProperty());
    roomRepository.createRoom.mockResolvedValue(makeRoom());
    const dto = validDto();
    dto.monthly_rent = 0;
    await expect(
      service.execute(propertyId, landlordId, dto),
    ).rejects.toThrow();
  });

  // BUG: service phải reject area_sqm = 0 (BVA-07 / ROOM-07)
  // Cần sửa DTO: @Min(1) thay vì @Min(0)
  it('[BUG] BVA-07 / ROOM-07: area_sqm = 0 should reject → actually accepted', async () => {
    const { service, roomRepository, propertiesRepository } = createService();
    propertiesRepository.findById.mockResolvedValue(makeProperty());
    roomRepository.createRoom.mockResolvedValue(makeRoom());
    const dto = validDto();
    dto.area_sqm = 0;
    await expect(
      service.execute(propertyId, landlordId, dto),
    ).rejects.toThrow();
  });
});
