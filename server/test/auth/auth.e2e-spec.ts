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
    email: `tenant-${Date.now()}-${Math.random().toString(36).slice(2, 6)}@test.com`,
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
              SMTP_FROM: 'test@test.com',
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
      data: { user: { id: '00000000-0000-0000-0000-000000000001', email: 'tenant@test.com' } },
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

  // ===================================================================
  // BVA: REGISTER — PASSWORD BOUNDARY
  // ===================================================================

  describe('BVA - Register password length', () => {
    it('AUTH-012: Password 7 chars (min-1) → 400', async () => {
      const payload = registerPayload({
        password: 'A1@bcde',
        confirm_password: 'A1@bcde',
      });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });

    it('AUTH-013: Password 8 chars (min) → 201', async () => {
      const payload = registerPayload({
        password: 'A1@bcdef',
        confirm_password: 'A1@bcdef',
      });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-053: Password 9 chars (min+1) → 201', async () => {
      const payload = registerPayload({
        password: 'A1@bcdefg',
        confirm_password: 'A1@bcdefg',
      });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-054: Password 71 chars (max-1) → 201', async () => {
      const payload = registerPayload({
        password: 'A1@' + 'a'.repeat(68),
        confirm_password: 'A1@' + 'a'.repeat(68),
      });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-014: Password 72 chars (max) → 201', async () => {
      const payload = registerPayload({
        password: 'A1@' + 'a'.repeat(69),
        confirm_password: 'A1@' + 'a'.repeat(69),
      });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-015: Password 73 chars (max+1) → 400', async () => {
      const payload = registerPayload({
        password: 'A1@' + 'a'.repeat(70),
        confirm_password: 'A1@' + 'a'.repeat(70),
      });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });
  });

  // ===================================================================
  // BVA: REGISTER — PHONE BOUNDARY
  // ===================================================================

  describe('BVA - Register phone length', () => {
    it('AUTH-016: Phone 9 chars (min-1) → 400', async () => {
      const payload = registerPayload({ phone: '012345678' });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });

    it('AUTH-017: Phone 10 chars (min) → 201', async () => {
      const payload = registerPayload({ phone: '0123456789' });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-055: Phone 11 chars (min+1) → 201', async () => {
      const payload = registerPayload({ phone: '01234567890' });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-018: Phone 15 chars (max) → 201', async () => {
      const payload = registerPayload({ phone: '012345678901234' });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-019: Phone 16 chars (max+1) → 400', async () => {
      const payload = registerPayload({ phone: '0123456789012345' });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });
  });

  // ===================================================================
  // BVA: REGISTER — FULLNAME BOUNDARY
  // ===================================================================

  describe('BVA - Register fullName length', () => {
    it('AUTH-020: fullName 1 char (min-1) → 400', async () => {
      const payload = registerPayload({ fullName: 'A' });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });

    it('AUTH-056: fullName 2 chars (min) → 201', async () => {
      const payload = registerPayload({ fullName: 'An' });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-057: fullName 99 chars (max-1) → 201', async () => {
      const payload = registerPayload({ fullName: 'A'.repeat(99) });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-021: fullName 100 chars (max) → 201', async () => {
      const payload = registerPayload({ fullName: 'A'.repeat(100) });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-022: fullName 101 chars (max+1) → 400', async () => {
      const payload = registerPayload({ fullName: 'A'.repeat(101) });
      await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });
  });

  // ===================================================================
  // BVA: REGISTER — IDENTITY NUMBER BOUNDARY
  // ===================================================================

  describe('BVA - Register identity_number length', () => {
    it('AUTH-023: identity_number 11 chars (exact-1) → 400', async () => {
      const payload = landlordPayload({ identity_number: '1'.repeat(11) });
      await request(app.getHttpServer())
        .post('/api/auth/register/landlord')
        .send(payload)
        .expect(400);
    });

    it('AUTH-024: identity_number 12 chars (exact) → 201', async () => {
      const payload = landlordPayload({ identity_number: '1'.repeat(12) });
      await request(app.getHttpServer())
        .post('/api/auth/register/landlord')
        .send(payload)
        .expect(201);
    });

    it('AUTH-025: identity_number 13 chars (exact+1) → 400', async () => {
      const payload = landlordPayload({ identity_number: '1'.repeat(13) });
      await request(app.getHttpServer())
        .post('/api/auth/register/landlord')
        .send(payload)
        .expect(400);
    });
  });

  // ===================================================================
  // BVA: OTP LENGTH
  // ===================================================================

  describe('BVA - OTP length', () => {
    it('AUTH-036: Confirm OTP 5 chars (min-1) → 400', async () => {
      await request(app.getHttpServer())
        .post('/api/auth/confirm-otp')
        .send({ email: 'test@test.com', otp: '12345' })
        .expect(400);
    });

    it('AUTH-058: Confirm OTP 6 chars (exact) → 201', async () => {
      mockRedisService.getValue.mockResolvedValue({ otp: '123456', isVerified: false });
      await request(app.getHttpServer())
        .post('/api/auth/confirm-otp')
        .send({ email: 'test@test.com', otp: '123456' })
        .expect(201);
    });

    it('AUTH-059: Confirm OTP 7 chars (max+1) → 400', async () => {
      await request(app.getHttpServer())
        .post('/api/auth/confirm-otp')
        .send({ email: 'test@test.com', otp: '1234567' })
        .expect(400);
    });
  });

  // ===================================================================
  // DT: PASSWORD RESET LIFECYCLE
  // ===================================================================

  describe('DT - Reset password lifecycle', () => {
    const resetPayload = (overrides: Record<string, any> = {}) => ({
      email: 'exists@test.com',
      otp: '123456',
      newPassword: 'NewPass1@',
      confirmPassword: 'NewPass1@',
      ...overrides,
    });

    it('AUTH-041: Login with old password fails after reset', async () => {
      mockRedisService.getValue.mockResolvedValue({ otp: '123456', isVerified: true });
      mockSupabaseAuthAdmin.listUsers.mockResolvedValue({
        data: { users: [{ id: 'existing-user', email: 'exists@test.com' }] },
        error: null,
      });

      await request(app.getHttpServer())
        .post('/api/auth/reset-password')
        .send(resetPayload())
        .expect(201);

      mockSupabaseAuth.signInWithPassword.mockResolvedValue({
        data: { session: null },
        error: { status: 400, message: 'Invalid login credentials' },
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/login')
        .send({ email: 'exists@test.com', password: 'Test@1234' })
        .expect(401);

      expect(res.body.statusCode).toBe(401);
    });

    it('AUTH-042: Login with new password succeeds after reset', async () => {
      mockSupabaseAuth.signInWithPassword.mockResolvedValue({
        data: {
          session: { access_token: 'mock-jwt-token' },
          user: { id: '00000000-0000-0000-0000-000000000001' },
        },
        error: null,
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/login')
        .send({ email: 'exists@test.com', password: 'NewPass1@' })
        .expect(201);

      expect(res.body.data.token).toBeDefined();
    });

    it('AUTH-043: OTP bypass — wrong OTP but isVerified=true still succeeds', async () => {
      mockRedisService.getValue.mockResolvedValue({ otp: '123456', isVerified: true });
      mockSupabaseAuthAdmin.listUsers.mockResolvedValue({
        data: { users: [{ id: 'existing-user', email: 'exists@test.com' }] },
        error: null,
      });

      await request(app.getHttpServer())
        .post('/api/auth/reset-password')
        .send(resetPayload({ otp: '000000' }))
        .expect(201);
    });
  });

  // ===================================================================
  // DT: ACCESS CONTROL
  // ===================================================================

  describe('DT - Access Control', () => {
    it('AUTH-047: Public endpoint without auth → 200', async () => {
      mockUserRepository.findById.mockResolvedValue(createMockUser());
      await request(app.getHttpServer())
        .get('/api/users/some-id')
        .expect(200);
    });

    it('AUTH-048: Protected endpoint without token → 401', async () => {
      await request(app.getHttpServer())
        .get('/api/profile')
        .expect(401);
    });

    it('AUTH-049: Empty Bearer token → 401', async () => {
      await request(app.getHttpServer())
        .get('/api/profile')
        .set('Authorization', 'Bearer ')
        .expect(401);
    });

    it('AUTH-050: Fake Bearer token → 401', async () => {
      mockSupabaseClient.auth.getUser.mockResolvedValue({
        data: { user: null },
        error: { message: 'Invalid token' },
      });

      await request(app.getHttpServer())
        .get('/api/profile')
        .set('Authorization', 'Bearer fake-jwt-token')
        .expect(401);
    });

    it('AUTH-051: RolesGuard allows required role → 200', async () => {
      await request(app.getHttpServer())
        .get('/api/test-roles/tenant')
        .set('Authorization', 'Bearer valid-jwt-token')
        .expect(200);
    });

    it('AUTH-052: RolesGuard forbids missing role → 403', async () => {
      await request(app.getHttpServer())
        .get('/api/test-roles/admin')
        .set('Authorization', 'Bearer valid-jwt-token')
        .expect(403);
    });
  });
});
