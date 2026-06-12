import { Test, TestingModule } from '@nestjs/testing';
import { Controller, Get, INestApplication, UseGuards, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import request from 'supertest';
import { App } from 'supertest/types';
import { AuthModule } from '../../src/modules/auth/presentation/auth.module';
import { SupabaseService } from '../../src/shared/infrastructure/supabase/supabase.service';
import { RedisService } from '../../src/shared/infrastructure/redis/redis.service';
import { MailService } from '../../src/shared/infrastructure/mail/mail.service';
import { UserRepository } from '../../src/modules/users/domain/repositories/user.repository';
import { DrizzleService } from '../../src/shared/infrastructure/database/drizzle.service';
import { HttpResponseInterceptor } from '../../src/shared/common/interceptors/HttpResponse.interceptor';
import { HttpExceptionFilter } from '../../src/shared/common/filter/HttpException.filter';
import { AuthGuard } from '../../src/shared/common/guards/auth.guard';
import { RolesGuard } from '../../src/shared/common/guards/roles.guard';
import { Roles } from '../../src/shared/common/decorators/roles.decorator';

// ---------------------------------------------------------------------------
// Mock definitions
// ---------------------------------------------------------------------------

const mockSupabaseAuthAdmin = {
  createUser: jest.fn(),
  deleteUser: jest.fn(),
  listUsers: jest.fn(),
  updateUserById: jest.fn(),
};

const mockSupabaseAuth = {
  admin: mockSupabaseAuthAdmin,
  signInWithPassword: jest.fn(),
  getUser: jest.fn(),
};

const mockSupabaseClient = {
  auth: mockSupabaseAuth,
};

const mockSupabaseService = {
  getClient: jest.fn(() => mockSupabaseClient),
};

const mockRedisClient = {
  set: jest.fn(),
  get: jest.fn(),
  del: jest.fn(),
};

const mockRedisService = {
  getClient: jest.fn(() => mockRedisClient),
  getValue: jest.fn(),
};

const mockMailService = {
  sendOtpEmail: jest.fn(),
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

@Controller('test-roles')
@UseGuards(AuthGuard, RolesGuard)
class TestRolesController {
  @Get('tenant')
  @Roles('tenant')
  getTenant() {
    return { ok: true };
  }

  @Get('admin')
  @Roles('admin')
  getAdmin() {
    return { ok: true };
  }
}

function createMockUser(overrides: Record<string, any> = {}) {
  return {
    id: '00000000-0000-0000-0000-000000000001',
    phone: null,
    identityNumber: null,
    fullName: 'Nguyen Van A',
    avatarUrl: null,
    role: ['tenant'],
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    acceptedTerms: true,
    dateOfBirth: null,
    ...overrides,
  };
}

const mockUserRepository = {
  findById: jest.fn(),
  findByPhone: jest.fn(),
  findByIdentityNumber: jest.fn(),
  create: jest.fn(),
  updateProfile: jest.fn(),
};

// ---------------------------------------------------------------------------
// Test data helpers
// ---------------------------------------------------------------------------

function registerPayload(overrides: Record<string, any> = {}) {
  return {
    email: `tenant-${Date.now()}-${Math.random().toString(36).slice(2, 6)}@gmail.com`,
    fullName: 'Nguyen Van A',
    phone: '0912345678',
    password: 'Test@1234',
    confirm_password: 'Test@1234',
    accepted_terms: true,
    ...overrides,
  };
}

function landlordPayload(overrides: Record<string, any> = {}) {
  return {
    ...registerPayload(),
    identity_number: '123456789012',
    ...overrides,
  };
}

// ---------------------------------------------------------------------------
// Test suite
// ---------------------------------------------------------------------------

describe('AuthModule (e2e)', () => {
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
              SMTP_FROM: 'test@gmail.com',
              VNPAY_TMN_CODE: 'test',
              VNPAY_HASH_SECRET: 'test',
              VNPAY_BASE_URL: 'https://test.com',
              VNPAY_IPN_URL: 'https://test.com',
              VNPAY_RETURN_URL: 'https://test.com',
            }),
          ],
        }),
        AuthModule,
      ],
      controllers: [TestRolesController],
      providers: [RolesGuard, AuthGuard],
    })
      .overrideProvider(SupabaseService)
      .useValue(mockSupabaseService)
      .overrideProvider(RedisService)
      .useValue(mockRedisService)
      .overrideProvider(MailService)
      .useValue(mockMailService)
      .overrideProvider(DrizzleService)
      .useValue(mockDrizzleService)
      .overrideProvider(UserRepository)
      .useValue(mockUserRepository)
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

    mockSupabaseAuthAdmin.createUser.mockImplementation((input: any) =>
      Promise.resolve({
        data: { user: { id: '00000000-0000-0000-0000-000000000001', email: input.email } },
        error: null,
      }),
    );

    mockSupabaseAuthAdmin.listUsers.mockResolvedValue({
      data: { users: [] },
      error: null,
    });

    mockSupabaseAuthAdmin.updateUserById.mockResolvedValue({
      data: { user: { id: '00000000-0000-0000-0000-000000000001' } },
      error: null,
    });

    mockSupabaseAuth.signInWithPassword.mockResolvedValue({
      data: {
        session: { access_token: 'mock-jwt-token' },
        user: { id: '00000000-0000-0000-0000-000000000001' },
      },
      error: null,
    });

    mockUserRepository.create.mockImplementation((input: any, role = 'tenant') =>
      Promise.resolve(createMockUser({ id: input.id, phone: input.phone, fullName: input.fullName, role: [role] })),
    );

    mockUserRepository.findById.mockResolvedValue(createMockUser());

    mockSupabaseAuth.getUser.mockResolvedValue({
      data: { user: { id: '00000000-0000-0000-0000-000000000001', email: 'tenant@gmail.com' } },
      error: null,
    });

    (mockDrizzleService.db.query.users.findFirst as jest.Mock).mockResolvedValue({
      id: '00000000-0000-0000-0000-000000000001',
      phone: '0912345678',
      fullName: 'Nguyen Van A',
      avatarUrl: null,
      roles: [{ role: 'tenant' }],
    });

    mockRedisService.getValue.mockResolvedValue(null);
    mockRedisClient.set.mockResolvedValue('OK');
    mockRedisClient.get.mockResolvedValue(null);
    mockRedisClient.del.mockResolvedValue(1);
    mockMailService.sendOtpEmail.mockResolvedValue(undefined);
  });

  afterAll(async () => {
    await app.close();
  });
});
