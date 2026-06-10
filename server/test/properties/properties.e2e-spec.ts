import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import request from 'supertest';
import { App } from 'supertest/types';
import { PropertiesModule } from '../../src/modules/properties/presentation/properties.module';
import { SupabaseService } from '../../src/shared/infrastructure/supabase/supabase.service';
import { DrizzleService } from '../../src/shared/infrastructure/database/drizzle.service';
import { PropertiesRepository } from '../../src/modules/properties/domain/repositories/properties.repository';
import { HttpResponseInterceptor } from '../../src/shared/common/interceptors/HttpResponse.interceptor';
import { HttpExceptionFilter } from '../../src/shared/common/filter/HttpException.filter';
import { Amenity } from '../../src/shared/infrastructure/database/enum/amenity';

const LANDLORD_ID = '00000000-0000-0000-0000-000000000001';
const PROPERTY_ID = '00000000-0000-0000-0000-000000000010';

function makeProperty() {
  return {
    id: PROPERTY_ID,
    landlorerId: LANDLORD_ID,
    name: 'Nha tro Hoa Phuong',
    address: '12 Nguyen Trai',
    ward: 'Phuong 5',
    district: 'Quan 3',
    city: 'TP Ho Chi Minh',
    description: 'Khu tro an ninh, gan truong hoc.',
    amenityCodes: [Amenity.WIFI, Amenity.AIR_CONDITIONER],
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

function validCreatePayload(overrides: Record<string, any> = {}) {
  return {
    name: 'Nha tro Hoa Phuong',
    address: '12 Nguyen Trai',
    ward: 'Phuong 5',
    district: 'Quan 3',
    city: 'TP Ho Chi Minh',
    description: 'Khu tro an ninh, gan truong hoc.',
    amenityCodes: [Amenity.WIFI, Amenity.AIR_CONDITIONER],
    ...overrides,
  };
}

// ---------------------------------------------------------------------------
// Mocks
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

const mockPropertiesRepository = {
  createProperty: jest.fn(),
  findAllByLandlordId: jest.fn(),
  findById: jest.fn(),
  updateProperty: jest.fn(),
  deleteProperty: jest.fn(),
};

// ---------------------------------------------------------------------------
// Test suite
// ---------------------------------------------------------------------------

describe('PropertiesModule (e2e) — EP & DT', () => {
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
        PropertiesModule,
      ],
    })
      .overrideProvider(SupabaseService)
      .useValue(mockSupabaseService)
      .overrideProvider(DrizzleService)
      .useValue(mockDrizzleService)
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

    mockPropertiesRepository.createProperty.mockResolvedValue(makeProperty());
  });

  afterAll(async () => {
    await app.close();
  });

  // ===================================================================
  // EP: Create Property
  // ===================================================================

  describe('EP — Create property', () => {
    const baseUrl = '/api/properties';

    it('PROP-01: Create property thành công với dữ liệu hợp lệ → 201', async () => {
      const payload = validCreatePayload();

      const res = await request(app.getHttpServer())
        .post(baseUrl)
        .set('Authorization', 'Bearer valid-token')
        .send(payload)
        .expect(201);

      expect(res.body.data.name).toBe(payload.name);
      expect(res.body.data.landlored.id).toBe(LANDLORD_ID);
      expect(mockPropertiesRepository.createProperty).toHaveBeenCalledWith(
        expect.objectContaining({
          landlorerId: LANDLORD_ID,
          name: payload.name,
          amenityCodes: payload.amenityCodes,
        }),
      );
    });
  });

  // ===================================================================
  // DT: Decision Table — Access Control
  // ===================================================================

  describe('DT — Access control', () => {
    const baseUrl = '/api/properties';

    it('PROP-04 / Rule 2: Create với tenant token → 403', async () => {
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
