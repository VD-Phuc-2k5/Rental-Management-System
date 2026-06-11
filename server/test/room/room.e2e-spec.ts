import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import request from 'supertest';
import { App } from 'supertest/types';
import { RoomsModule } from '../../src/modules/rooms/presentation/room.module';
import { SupabaseService } from '../../src/shared/infrastructure/supabase/supabase.service';
import { DrizzleService } from '../../src/shared/infrastructure/database/drizzle.service';
import { RoomRepository } from '../../src/modules/rooms/domain/repositories/room.repository';
import { BrowseRoomRepository } from '../../src/modules/rooms/domain/repositories/browse-room.repository';
import { PropertiesRepository } from '../../src/modules/properties/domain/repositories/properties.repository';
import { HttpResponseInterceptor } from '../../src/shared/common/interceptors/HttpResponse.interceptor';
import { HttpExceptionFilter } from '../../src/shared/common/filter/HttpException.filter';

// ---------------------------------------------------------------------------
// Mock definitions
// ---------------------------------------------------------------------------

const mockSupabaseAuth = {
  getUser: jest.fn(),
};

const mockSupabaseClient = {
  auth: mockSupabaseAuth,
};

const mockSupabaseService = {
  getClient: jest.fn(() => mockSupabaseClient),
};

const mockDrizzleService = {
  db: {
    query: {
      users: {
        findFirst: jest.fn(),
      },
    },
  },
};

const mockRoomRepository = {
  createRoom: jest.fn(),
  findAllByPropertyId: jest.fn(),
  findById: jest.fn(),
  updateRoom: jest.fn(),
  deleteRoom: jest.fn(),
};

const mockBrowseRoomRepository = {
  findAvailable: jest.fn(),
  findDetailById: jest.fn(),
};

const mockPropertiesRepository = {
  createProperty: jest.fn(),
  findAllByLandlordId: jest.fn(),
  findById: jest.fn(),
  updateProperty: jest.fn(),
  deleteProperty: jest.fn(),
};

// ---------------------------------------------------------------------------
// Test data helpers
// ---------------------------------------------------------------------------

const LANDLORD_ID = '00000000-0000-0000-0000-000000000001';
const PROPERTY_ID = '00000000-0000-0000-0000-000000000010';
const ROOM_ID = '00000000-0000-0000-0000-000000000020';

function validCreatePayload(overrides: Record<string, any> = {}) {
  return {
    title: 'Phong 101',
    area_sqm: 25,
    monthly_rent: 3000000,
    deposit_amount: 6000000,
    electricity_rate_per_kwh: 3500,
    water_rate_per_m3: 15000,
    ...overrides,
  };
}

function makeProperty() {
  return {
    id: PROPERTY_ID,
    landlorerId: LANDLORD_ID,
    name: 'Chung cu A',
    address: '123 Le Loi',
  };
}

function makeRoom() {
  return {
    id: ROOM_ID,
    propertyId: PROPERTY_ID,
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
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };
}

function makeUser(overrides: Record<string, any> = {}) {
  return {
    id: LANDLORD_ID,
    phone: '0912345678',
    fullName: 'Landlord User',
    avatarUrl: null,
    roles: [{ role: 'landlord' }],
    ...overrides,
  };
}

// ---------------------------------------------------------------------------
// Test suite
// ---------------------------------------------------------------------------

describe('RoomsModule (e2e) — BVA & DT', () => {
  let app: INestApplication<App>;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [
        ConfigModule.forRoot({
          isGlobal: true,
          ignoreEnvFile: true,
          ignoreEnvVars: true,
          load: [
            () => ({
              SUPABASE_URL: 'https://test.supabase.co',
              SUPABASE_SERVICE_ROLE_KEY: 'mock-service-role-key-for-testing',
              DATABASE_URL: 'postgresql://test:test@localhost:5432/test',
              REDIS_URL: 'redis://localhost:6379',
              SMTP_HOST: 'smtp.test.com',
              SMTP_PORT: '587',
              SMTP_USER: 'test',
              SMTP_PASS: 'test',
              SMTP_FROM: 'test@test.com',
              VNPAY_TMN_CODE: 'test',
              VNPAY_HASH_SECRET: 'test',
              VNPAY_BASE_URL: 'https://test.com',
              VNPAY_IPN_URL: 'https://test.com',
              VNPAY_RETURN_URL: 'https://test.com',
            }),
          ],
        }),
        RoomsModule,
      ],
    })
      .overrideProvider(SupabaseService)
      .useValue(mockSupabaseService)
      .overrideProvider(DrizzleService)
      .useValue(mockDrizzleService)
      .overrideProvider(RoomRepository)
      .useValue(mockRoomRepository)
      .overrideProvider(BrowseRoomRepository)
      .useValue(mockBrowseRoomRepository)
      .overrideProvider(PropertiesRepository)
      .useValue(mockPropertiesRepository)
      .compile();

    app = moduleFixture.createNestApplication();
    app.setGlobalPrefix('api');
    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );
    app.useGlobalInterceptors(new HttpResponseInterceptor());
    app.useGlobalFilters(new HttpExceptionFilter());
    await app.init();
  });

  beforeEach(() => {
    jest.clearAllMocks();

    mockSupabaseAuth.getUser.mockResolvedValue({
      data: { user: { id: LANDLORD_ID, email: 'landlord@test.com' } },
      error: null,
    });

    (mockDrizzleService.db.query.users.findFirst as jest.Mock).mockResolvedValue(
      makeUser(),
    );

    mockPropertiesRepository.findById.mockResolvedValue(makeProperty());
    mockRoomRepository.createRoom.mockResolvedValue(makeRoom());
  });

  afterAll(async () => {
    await app.close();
  });

  // ===================================================================
  // BVA: monthly_rent — Create Room
  // ===================================================================

  describe('BVA — monthly_rent (create room)', () => {
    const baseUrl = `/api/properties/${PROPERTY_ID}/rooms`;

    it('BVA-01: monthly_rent = -2000000 (biên dưới - 2) → 400', async () => {
      await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer valid-token')
        .send(validCreatePayload({ monthly_rent: -2000000 }))
        .expect(400);
    });

    it('BVA-02 / ROOM-04: monthly_rent = -1000000 (biên dưới - 1) → 400', async () => {
      await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer valid-token')
        .send(validCreatePayload({ monthly_rent: -1000000 }))
        .expect(400);
    });

    it('BVA-03 / ROOM-05: monthly_rent = 0 (biên chính xác) → 400', async () => {
      await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer valid-token')
        .send(validCreatePayload({ monthly_rent: 0 }))
        .expect(400);
    });

    it('BVA-04 / ROOM-06: monthly_rent = 1 (biên trên + 1) → 201', async () => {
      await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer valid-token')
        .send(validCreatePayload({ monthly_rent: 1 }))
        .expect(201);
    });

    it('BVA-05: monthly_rent = 1000000 (lớp hợp lệ) → 201', async () => {
      await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer valid-token')
        .send(validCreatePayload({ monthly_rent: 1000000 }))
        .expect(201);
    });
  });

  // ===================================================================
  // BVA: area_sqm — Create Room
  // ===================================================================

  describe('BVA — area_sqm (create room)', () => {
    const baseUrl = `/api/properties/${PROPERTY_ID}/rooms`;

    it('BVA-06: area_sqm = -1 (biên dưới - 1) → 400', async () => {
      await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer valid-token')
        .send(validCreatePayload({ area_sqm: -1 }))
        .expect(400);
    });

    it('BVA-07 / ROOM-07: area_sqm = 0 (biên chính xác) → 400', async () => {
      await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer valid-token')
        .send(validCreatePayload({ area_sqm: 0 }))
        .expect(400);
    });

    it('BVA-08: area_sqm = 1 (biên trên + 1) → 201', async () => {
      await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer valid-token')
        .send(validCreatePayload({ area_sqm: 1 }))
        .expect(201);
    });
  });

  // ===================================================================
  // DT — Browse Room Detail
  // ===================================================================

  describe('DT — Browse room detail', () => {
    it('ROOM-22 / Rule 1: Room tồn tại + token hợp lệ → 200', async () => {
      mockBrowseRoomRepository.findDetailById.mockResolvedValue({
        id: ROOM_ID,
        propertyId: PROPERTY_ID,
        title: 'Phong 101',
        status: 'AVAILABLE',
        area_sqm: 25,
        monthly_rent: 3000000,
        deposit_amount: 6000000,
        electricity_rate_per_kwh: 3500,
        water_rate_per_m3: 15000,
        has_furniture: false,
        description: null,
        included_amenity_codes: [],
        addon_amenities: [],
        parking_fees: null,
        images: [],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      });

      const res = await request(app.getHttpServer())
        .get(`/api/browse/rooms/${ROOM_ID}`)
        .set('Authorization', 'Bearer valid-token')
        .expect(200);

      expect(res.body.data.id).toBe(ROOM_ID);
    });

    it('ROOM-23 / Rule 2: Room không tồn tại + token hợp lệ → 404', async () => {
      mockBrowseRoomRepository.findDetailById.mockResolvedValue(null);

      await request(app.getHttpServer())
        .get(`/api/browse/rooms/${ROOM_ID}`)
        .set('Authorization', 'Bearer valid-token')
        .expect(404);
    });

    it('ROOM-24 / Rule 3: Room tồn tại + không token → 401', async () => {
      await request(app.getHttpServer())
        .get(`/api/browse/rooms/${ROOM_ID}`)
        .expect(401);
    });
  });

  // ===================================================================
  // DT — Role-based Access Control
  // ===================================================================

  describe('DT — Role-based access', () => {
    const baseUrl = `/api/properties/${PROPERTY_ID}/rooms`;

    it('ROOM-08: Create room với tenant token → 403', async () => {
      (mockDrizzleService.db.query.users.findFirst as jest.Mock).mockResolvedValue(
        makeUser({ roles: [{ role: 'tenant' }] }),
      );

      await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer tenant-token')
        .send(validCreatePayload())
        .expect(403);
    });
  });
});
