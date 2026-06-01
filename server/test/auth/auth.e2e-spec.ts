import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication, ValidationPipe } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import request from 'supertest';
import { App } from 'supertest/types';
import { AuthModule } from '../../src/modules/auth/presentation/auth.module';
import { UsersModule } from '../../src/modules/users/presentation/user.module';
import { SupabaseModule } from '../../src/shared/infrastructure/supabase/supabase.module';
import { DrizzleModule } from '../../src/shared/infrastructure/database/drizzle.module';
import { RedisModule } from '../../src/shared/infrastructure/redis/redis.module';
import { MailModule } from '../../src/shared/infrastructure/mail/mail.module';
import { SupabaseService } from '../../src/shared/infrastructure/supabase/supabase.service';
import { RedisService } from '../../src/shared/infrastructure/redis/redis.service';
import { MailService } from '../../src/shared/infrastructure/mail/mail.service';
import { UserRepository } from '../../src/modules/users/domain/repositories/user.repository';
import { DrizzleService } from '../../src/shared/infrastructure/database/drizzle.service';
import { HttpResponseInterceptor } from '../../src/shared/common/interceptors/HttpResponse.interceptor';
import { HttpExceptionFilter } from '../../src/shared/common/filter/HttpException.filter';

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
  db: {} as any,
};

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

function loginPayload(email?: string) {
  return {
    email: email ?? `tenant-${Date.now()}@test.com`,
    password: 'Test@1234',
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

    mockRedisService.getValue.mockResolvedValue(null);
    mockRedisClient.set.mockResolvedValue('OK');
    mockRedisClient.get.mockResolvedValue(null);
    mockRedisClient.del.mockResolvedValue(1);
    mockMailService.sendOtpEmail.mockResolvedValue(undefined);
  });

  afterAll(async () => {
    await app.close();
  });

  // =========================================================
  // REGISTER
  // =========================================================

  describe('POST /api/auth/register/user - Register tenant', () => {
    it('AUTH-001: Register tenant successfully', async () => {
      const payload = registerPayload();

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);

      expect(res.body.statusCode).toBe(201);
      expect(res.body.message).toBe('Success');
      expect(res.body.data.role).toBe('tenant');
      expect(res.body.data.email).toBe(payload.email);
      expect(res.body.data.id).toBeDefined();
    });

    it('AUTH-002: Register landlord successfully', async () => {
      const payload = landlordPayload();

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/landlord')
        .send(payload)
        .expect(201);

      expect(res.body.statusCode).toBe(201);
      expect(res.body.data.role).toBe('landlord');
    });

    it('AUTH-003: Email already exists', async () => {
      const existingEmail = 'existing@test.com';
      mockSupabaseAuthAdmin.listUsers.mockResolvedValue({
        data: { users: [{ id: 'existing-id', email: existingEmail }] },
        error: null,
      });

      const payload = registerPayload({ email: existingEmail });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload);

      expect(res.status).toBe(409);
      expect(res.body.message).toContain('Email');
    });

    it('AUTH-004: Invalid email format', async () => {
      const payload = registerPayload({ email: 'invalid' });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });

    it('AUTH-005: Empty email', async () => {
      const payload = registerPayload({ email: '' });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });

    it('AUTH-006: Missing password', async () => {
      const payload = registerPayload();
      delete payload.password;
      delete payload.confirm_password;

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });

    it('AUTH-007: Weak password - missing special char', async () => {
      const payload = registerPayload({
        password: 'Aa111111',
        confirm_password: 'Aa111111',
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);

      expect(res.body.details.message[0]).toContain('Mật khẩu phải có');
    });

    it('AUTH-008: Confirm password mismatch', async () => {
      const payload = registerPayload({
        confirm_password: 'Bb222222@',
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });

    it('AUTH-009: accepted_terms false', async () => {
      const payload = registerPayload({ accepted_terms: false });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });

    it('AUTH-010: Phone contains letters', async () => {
      const payload = registerPayload({ phone: 'abc123' });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);

      expect(res.body.details.message[0]).toContain('chữ số');
    });

    it('AUTH-011: Empty fullName', async () => {
      const payload = registerPayload({ fullName: '' });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });

    // ---- BVA: Password ----
    it('AUTH-012: BVA - Password 7 chars (below min)', async () => {
      const payload = registerPayload({
        password: 'A1@bcde',
        confirm_password: 'A1@bcde',
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });

    it('AUTH-013: BVA - Password 8 chars (min)', async () => {
      const payload = registerPayload({
        password: 'A1@bcdef',
        confirm_password: 'A1@bcdef',
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-014: BVA - Password 72 chars (max)', async () => {
      const payload = registerPayload({
        password: 'A1@' + 'a'.repeat(69),
        confirm_password: 'A1@' + 'a'.repeat(69),
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-015: BVA - Password 73 chars (above max)', async () => {
      const payload = registerPayload({
        password: 'A1@' + 'a'.repeat(70),
        confirm_password: 'A1@' + 'a'.repeat(70),
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });

    // ---- BVA: Phone ----
    it('AUTH-016: BVA - Phone 9 chars (below min)', async () => {
      const payload = registerPayload({ phone: '012345678' });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });

    it('AUTH-017: BVA - Phone 10 chars (min)', async () => {
      const payload = registerPayload({ phone: '0123456789' });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-018: BVA - Phone 15 chars (max)', async () => {
      const payload = registerPayload({ phone: '012345678901234' });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-019: BVA - Phone 16 chars (above max)', async () => {
      const payload = registerPayload({ phone: '0123456789012345' });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });

    // ---- BVA: fullName ----
    it('AUTH-020: BVA - fullName 1 char (below min)', async () => {
      const payload = registerPayload({ fullName: 'A' });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });

    it('AUTH-021: BVA - fullName 100 chars (max)', async () => {
      const payload = registerPayload({ fullName: 'A'.repeat(100) });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(201);
    });

    it('AUTH-022: BVA - fullName 101 chars (above max)', async () => {
      const payload = registerPayload({ fullName: 'A'.repeat(101) });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/user')
        .send(payload)
        .expect(400);
    });

    // ---- BVA: identity_number ----
    it('AUTH-023: BVA - identity_number 11 chars (below exact)', async () => {
      const payload = landlordPayload({ identity_number: '1'.repeat(11) });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/landlord')
        .send(payload)
        .expect(400);
    });

    it('AUTH-024: BVA - identity_number 12 chars (exact)', async () => {
      const payload = landlordPayload({ identity_number: '1'.repeat(12) });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/landlord')
        .send(payload)
        .expect(201);
    });

    it('AUTH-025: BVA - identity_number 13 chars (above exact)', async () => {
      const payload = landlordPayload({ identity_number: '1'.repeat(13) });

      const res = await request(app.getHttpServer())
        .post('/api/auth/register/landlord')
        .send(payload)
        .expect(400);
    });
  });

  // =========================================================
  // LOGIN
  // =========================================================

  describe('POST /api/auth/login - Login', () => {
    it('AUTH-026: Login tenant successfully', async () => {
      const payload = loginPayload('tenant-login@test.com');

      const res = await request(app.getHttpServer())
        .post('/api/auth/login')
        .send(payload)
        .expect(201);

      expect(res.body.data.token).toBeDefined();
      expect(res.body.data.user).toBeDefined();
    });

    it('AUTH-027: Login landlord successfully', async () => {
      mockUserRepository.findById.mockResolvedValue(
        createMockUser({ role: ['landlord'] }),
      );

      const payload = loginPayload('landlord-login@test.com');

      const res = await request(app.getHttpServer())
        .post('/api/auth/login')
        .send(payload)
        .expect(201);

      expect(res.body.data.user.role).toContain('landlord');
    });

    it('AUTH-028: Login wrong email', async () => {
      mockSupabaseAuth.signInWithPassword.mockResolvedValue({
        data: { session: null },
        error: { status: 400, message: 'Invalid login credentials' },
      });

      const payload = loginPayload('wrong@test.com');

      const res = await request(app.getHttpServer())
        .post('/api/auth/login')
        .send(payload)
        .expect(401);

      expect(res.body.statusCode).toBe(401);
    });

    it('AUTH-029: Login wrong password', async () => {
      mockSupabaseAuth.signInWithPassword.mockResolvedValue({
        data: { session: null },
        error: { status: 400, message: 'Invalid login credentials' },
      });

      const payload = { email: 'tenant-login@test.com', password: 'WrongPass1@' };

      const res = await request(app.getHttpServer())
        .post('/api/auth/login')
        .send(payload)
        .expect(401);

      expect(res.body.statusCode).toBe(401);
    });

    it('AUTH-030: Login empty email', async () => {
      const payload = { email: '', password: 'Test@1234' };

      const res = await request(app.getHttpServer())
        .post('/api/auth/login')
        .send(payload)
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });
  });

  // =========================================================
  // FORGOT / RESET PASSWORD
  // =========================================================

  describe('POST /api/auth/forgot-password - Forgot password', () => {
    it('AUTH-031: Forgot password successfully', async () => {
      mockSupabaseAuthAdmin.listUsers.mockResolvedValue({
        data: { users: [{ id: 'existing-user', email: 'exists@test.com' }] },
        error: null,
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/forgot-password')
        .send({ email: 'exists@test.com' })
        .expect(201);

      expect(res.body.statusCode).toBe(201);
    });

    it('AUTH-032: Forgot password - email not found (still 201 for security)', async () => {
      mockSupabaseAuthAdmin.listUsers.mockResolvedValue({
        data: { users: [] },
        error: null,
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/forgot-password')
        .send({ email: 'notfound@test.com' })
        .expect(201);

      expect(res.body.statusCode).toBe(201);
    });

    it('AUTH-033: Forgot password - missing email', async () => {
      const res = await request(app.getHttpServer())
        .post('/api/auth/forgot-password')
        .send({})
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });
  });

  describe('POST /api/auth/confirm-otp - Confirm OTP', () => {
    it('AUTH-034: Confirm OTP successfully', async () => {
      mockRedisService.getValue.mockResolvedValue({ otp: '123456', isVerified: false });

      const res = await request(app.getHttpServer())
        .post('/api/auth/confirm-otp')
        .send({ email: 'exists@test.com', otp: '123456' })
        .expect(201);

      expect(res.body.message).toBe('Success');
    });

    it('AUTH-035: Confirm OTP wrong code', async () => {
      mockRedisService.getValue.mockResolvedValue({ otp: '123456', isVerified: false });

      const res = await request(app.getHttpServer())
        .post('/api/auth/confirm-otp')
        .send({ email: 'exists@test.com', otp: '000000' })
        .expect(400);

      expect(res.body.message).toContain('OTP');
    });

    it('AUTH-036: Confirm OTP wrong length', async () => {
      const res = await request(app.getHttpServer())
        .post('/api/auth/confirm-otp')
        .send({ email: 'exists@test.com', otp: '12345' })
        .expect(400);

      expect(res.body.statusCode).toBe(400);
    });
  });

  describe('POST /api/auth/reset-password - Reset password', () => {
    const resetPayload = (overrides: Record<string, any> = {}) => ({
      email: 'exists@test.com',
      otp: '123456',
      newPassword: 'NewPass1@',
      confirmPassword: 'NewPass1@',
      ...overrides,
    });

    it('AUTH-037: Reset password successfully', async () => {
      mockRedisService.getValue.mockResolvedValue({ otp: '123456', isVerified: true });
      mockSupabaseAuthAdmin.listUsers.mockResolvedValue({
        data: { users: [{ id: 'existing-user', email: 'exists@test.com' }] },
        error: null,
      });

      const res = await request(app.getHttpServer())
        .post('/api/auth/reset-password')
        .send(resetPayload())
        .expect(201);

      expect(res.body.data.message).toContain('thành công');
    });

    it('AUTH-038: Reset password - wrong OTP', async () => {
      mockRedisService.getValue.mockResolvedValue({ otp: '123456', isVerified: false });

      const res = await request(app.getHttpServer())
        .post('/api/auth/reset-password')
        .send(resetPayload({ otp: '000000' }))
        .expect(400);

      expect(res.body.message).toContain('OTP');
    });

    it('AUTH-039: Reset password - weak new password', async () => {
      mockRedisService.getValue.mockResolvedValue({ otp: '123456', isVerified: true });

      const res = await request(app.getHttpServer())
        .post('/api/auth/reset-password')
        .send(resetPayload({ newPassword: 'weak', confirmPassword: 'weak' }))
        .expect(400);
    });

    it('AUTH-040: Reset password - confirm mismatch', async () => {
      mockRedisService.getValue.mockResolvedValue({ otp: '123456', isVerified: true });

      const res = await request(app.getHttpServer())
        .post('/api/auth/reset-password')
        .send(resetPayload({ confirmPassword: 'Diff1@ent' }))
        .expect(400);
    });

    // ---- DT: Reset-password lifecycle ----
    it('AUTH-041: Login with old password fails after reset (DT)', async () => {
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

    it('AUTH-042: Login with new password succeeds after reset (DT)', async () => {
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
  });

  // =========================================================
  // ACCESS CONTROL (DT - Decision Table)
  // =========================================================

  describe('Access Control - Decision Table', () => {
    it('AUTH-043: Public endpoint without auth', async () => {
      mockUserRepository.findById.mockResolvedValue(createMockUser());

      const res = await request(app.getHttpServer())
        .get('/api/users/some-id')
        .expect(200);

      expect(res.body.statusCode).toBe(200);
    });

    it('AUTH-044: Protected endpoint without token', async () => {
      const res = await request(app.getHttpServer())
        .get('/api/profile')
        .expect(401);

      expect(res.body.message).toContain('Authorization');
    });

    it('AUTH-045: Empty Bearer token', async () => {
      const res = await request(app.getHttpServer())
        .get('/api/profile')
        .set('Authorization', 'Bearer ')
        .expect(401);

      expect(res.body.statusCode).toBe(401);
    });

    it('AUTH-046: Fake Bearer token', async () => {
      mockSupabaseClient.auth.getUser.mockResolvedValue({
        data: { user: null },
        error: { message: 'Invalid token' },
      });

      const res = await request(app.getHttpServer())
        .get('/api/profile')
        .set('Authorization', 'Bearer fake-jwt-token')
        .expect(401);

      expect(res.body.message).toContain('không hợp lệ');
    });
  });
});
