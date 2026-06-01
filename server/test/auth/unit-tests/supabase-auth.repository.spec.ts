import { SupabaseAuthRepository } from '../../../src/modules/auth/infrastructure/supabase-auth.repository';
import { SupabaseService } from '../../../src/shared/infrastructure/supabase/supabase.service';
import {
  AuthOperationError,
  DuplicateEmailError,
  InvalidCredentialsError,
} from '../../../src/modules/auth/domain/errors/auth.errors';

function createRepository() {
  const mockAuthAdmin = {
    createUser: jest.fn(),
    deleteUser: jest.fn(),
    listUsers: jest.fn(),
    updateUserById: jest.fn(),
  };

  const mockAuth = {
    admin: mockAuthAdmin,
    signInWithPassword: jest.fn(),
  };

  const mockClient = { auth: mockAuth };

  const supabaseService: jest.Mocked<SupabaseService> = {
    getClient: jest.fn(() => mockClient as any),
  } as any;

  const repository = new SupabaseAuthRepository(supabaseService);
  return { repository, mockAuthAdmin, mockAuth };
}

describe('SupabaseAuthRepository', () => {
  it('registers user successfully', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.createUser.mockResolvedValue({
      data: { user: { id: 'user-1', email: 'user@test.com' } },
      error: null,
    });

    const result = await repository.register({
      email: 'user@test.com',
      password: 'Test@1234',
      confirmPassword: 'Test@1234',
      phone: '0912345678',
      identity_number: null,
      fullName: 'Nguyen Van A',
      avatarUrl: undefined,
      acceptTerms: true,
    });

    expect(result.id).toBe('user-1');
  });

  it('throws DuplicateEmailError for duplicate email', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.createUser.mockResolvedValue({
      data: { user: null },
      error: { message: 'already registered' },
    });

    await expect(
      repository.register({
        email: 'user@test.com',
        password: 'Test@1234',
        confirmPassword: 'Test@1234',
        phone: '0912345678',
        identity_number: null,
        fullName: 'Nguyen Van A',
        avatarUrl: undefined,
        acceptTerms: true,
      }),
    ).rejects.toBeInstanceOf(DuplicateEmailError);
  });

  it('throws AuthOperationError for mismatched password', async () => {
    const { repository } = createRepository();

    await expect(
      repository.register({
        email: 'user@test.com',
        password: 'Test@1234',
        confirmPassword: 'Diff@1234',
        phone: null,
        identity_number: null,
        fullName: 'Nguyen Van A',
        avatarUrl: undefined,
        acceptTerms: true,
      }),
    ).rejects.toBeInstanceOf(AuthOperationError);
  });

  it('throws AuthOperationError when login fails', async () => {
    const { repository, mockAuth } = createRepository();
    mockAuth.signInWithPassword.mockResolvedValue({
      data: { session: null },
      error: { status: 500, message: 'boom' },
    });

    await expect(repository.login('user@test.com', 'Test@1234'))
      .rejects
      .toBeInstanceOf(AuthOperationError);
  });

  it('throws InvalidCredentialsError for invalid login', async () => {
    const { repository, mockAuth } = createRepository();
    mockAuth.signInWithPassword.mockResolvedValue({
      data: { session: null },
      error: { status: 400, message: 'Invalid login credentials' },
    });

    await expect(repository.login('user@test.com', 'Test@1234'))
      .rejects
      .toBeInstanceOf(InvalidCredentialsError);
  });

  it('finds user id by email (case insensitive)', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.listUsers.mockResolvedValue({
      data: { users: [{ id: 'user-1', email: 'User@Test.com' }] },
      error: null,
    });

    const result = await repository.findUserIdByEmail('user@test.com');
    expect(result).toBe('user-1');
  });

  it('throws AuthOperationError when listUsers fails', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.listUsers.mockResolvedValue({
      data: { users: [] },
      error: { message: 'fail' },
    });

    await expect(repository.findUserIdByEmail('user@test.com'))
      .rejects
      .toBeInstanceOf(AuthOperationError);
  });

  it('throws AuthOperationError when updatePassword fails', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.updateUserById.mockResolvedValue({
      error: { message: 'fail' },
    });

    await expect(repository.updatePassword('user-1', 'NewPass1@'))
      .rejects
      .toBeInstanceOf(AuthOperationError);
  });

  it('throws AuthOperationError when acceptTerms is false', async () => {
    const { repository } = createRepository();

    await expect(
      repository.register({
        email: 'user@test.com',
        password: 'Test@1234',
        confirmPassword: 'Test@1234',
        phone: '0912345678',
        identity_number: null,
        fullName: 'Nguyen Van A',
        avatarUrl: undefined,
        acceptTerms: false,
      }),
    ).rejects.toBeInstanceOf(AuthOperationError);
  });

  it('throws AuthOperationError for unknown error in register', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.createUser.mockResolvedValue({
      data: { user: null },
      error: { message: 'some unexpected error' },
    });

    await expect(
      repository.register({
        email: 'user@test.com',
        password: 'Test@1234',
        confirmPassword: 'Test@1234',
        phone: null,
        identity_number: null,
        fullName: 'Nguyen Van A',
        avatarUrl: undefined,
        acceptTerms: true,
      }),
    ).rejects.toBeInstanceOf(AuthOperationError);
  });

  it('throws AuthOperationError when createUser returns no user and no error', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.createUser.mockResolvedValue({
      data: { user: null },
      error: null,
    });

    await expect(
      repository.register({
        email: 'user@test.com',
        password: 'Test@1234',
        confirmPassword: 'Test@1234',
        phone: null,
        identity_number: null,
        fullName: 'Nguyen Van A',
        avatarUrl: undefined,
        acceptTerms: true,
      }),
    ).rejects.toBeInstanceOf(AuthOperationError);
  });

  it('wraps unexpected error in register catch block', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.createUser.mockImplementation(() => {
      throw new Error('network failure');
    });

    await expect(
      repository.register({
        email: 'user@test.com',
        password: 'Test@1234',
        confirmPassword: 'Test@1234',
        phone: null,
        identity_number: null,
        fullName: 'Nguyen Van A',
        avatarUrl: undefined,
        acceptTerms: true,
      }),
    ).rejects.toBeInstanceOf(AuthOperationError);
  });

  it('detects duplicate email from various error messages', async () => {
    const messages = [
      'already been registered',
      'already registered',
      'already exists',
      'duplicate',
      'unique constraint',
      'email address has already',
    ];

    for (const msg of messages) {
      const { repository, mockAuthAdmin } = createRepository();
      mockAuthAdmin.createUser.mockResolvedValue({
        data: { user: null },
        error: { message: msg },
      });

      await expect(
        repository.register({
          email: 'user@test.com',
          password: 'Test@1234',
          confirmPassword: 'Test@1234',
          phone: null,
          identity_number: null,
          fullName: 'Nguyen Van A',
          avatarUrl: undefined,
          acceptTerms: true,
        }),
      ).rejects.toBeInstanceOf(DuplicateEmailError);
    }
  });

  it('logs in successfully', async () => {
    const { repository, mockAuth } = createRepository();
    mockAuth.signInWithPassword.mockResolvedValue({
      data: { session: { access_token: 'jwt' }, user: { id: 'user-1' } },
      error: null,
    });

    const result = await repository.login('user@test.com', 'Test@1234');

    expect(result.token).toBe('jwt');
    expect(result.userId).toBe('user-1');
  });

  it('throws AuthOperationError for non-credential login error', async () => {
    const { repository, mockAuth } = createRepository();
    mockAuth.signInWithPassword.mockResolvedValue({
      data: { session: null },
      error: { status: 500, message: 'internal error' },
    });

    await expect(repository.login('user@test.com', 'Test@1234'))
      .rejects
      .toBeInstanceOf(AuthOperationError);
  });

  it('wraps unexpected error in login catch block', async () => {
    const { repository, mockAuth } = createRepository();
    mockAuth.signInWithPassword.mockImplementation(() => {
      throw new Error('network failure');
    });

    await expect(repository.login('user@test.com', 'Test@1234'))
      .rejects
      .toBeInstanceOf(AuthOperationError);
  });

  it('deletes user successfully', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.deleteUser.mockResolvedValue({ error: null });

    await expect(repository.deleteUser('user-1')).resolves.toBeUndefined();
  });

  it('throws AuthOperationError when deleteUser fails', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.deleteUser.mockResolvedValue({
      error: { message: 'fail' },
    });

    await expect(repository.deleteUser('user-1'))
      .rejects
      .toBeInstanceOf(AuthOperationError);
  });

  it('returns null when email not found', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.listUsers.mockResolvedValue({
      data: { users: [] },
      error: null,
    });

    const result = await repository.findUserIdByEmail('nobody@test.com');
    expect(result).toBeNull();
  });

  it('wraps unexpected error in findUserIdByEmail catch block', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.listUsers.mockImplementation(() => {
      throw new Error('network failure');
    });

    await expect(repository.findUserIdByEmail('user@test.com'))
      .rejects
      .toBeInstanceOf(AuthOperationError);
  });

  it('updates password successfully', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.updateUserById.mockResolvedValue({ error: null });

    await expect(
      repository.updatePassword('user-1', 'NewPass1@'),
    ).resolves.toBeUndefined();
  });

  it('wraps unexpected error in updatePassword catch block', async () => {
    const { repository, mockAuthAdmin } = createRepository();
    mockAuthAdmin.updateUserById.mockImplementation(() => {
      throw new Error('network failure');
    });

    await expect(repository.updatePassword('user-1', 'NewPass1@'))
      .rejects
      .toBeInstanceOf(AuthOperationError);
  });
});
