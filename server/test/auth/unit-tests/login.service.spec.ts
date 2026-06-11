import {
  BadRequestException,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import { LoginService } from '../../../src/modules/auth/application/services/login.service';
import { AuthRepository } from '../../../src/modules/auth/domain/repositories/auth.repository';
import { UserRepository } from '../../../src/modules/users/domain/repositories/user.repository';
import {
  AuthOperationError,
  InvalidCredentialsError,
} from '../../../src/modules/auth/domain/errors/auth.errors';

describe('LoginService', () => {
  const email = 'tenant@test.com';
  const password = 'Test@1234';

  function createService() {
    const authRepository: jest.Mocked<AuthRepository> = {
      register: jest.fn(),
      deleteUser: jest.fn(),
      login: jest.fn(),
      findUserIdByEmail: jest.fn(),
      updatePassword: jest.fn(),
    };
    const userRepository: jest.Mocked<UserRepository> = {
      findById: jest.fn(),
      findByPhone: jest.fn(),
      findByIdentityNumber: jest.fn(),
      create: jest.fn(),
      updateProfile: jest.fn(),
    };

    const service = new LoginService(authRepository, userRepository);
    return { service, authRepository, userRepository };
  }

  it('returns token and user when login succeeds', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.login.mockResolvedValue({ token: 'jwt', userId: 'user-1' });
    userRepository.findById.mockResolvedValue({
      id: 'user-1',
      phone: '0912345678',
      identityNumber: null,
      fullName: 'Nguyen Van A',
      avatarUrl: null,
      role: ['tenant'],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      acceptedTerms: true,
      dateOfBirth: null,
    });

    const result = await service.execute(email, password);

    expect(result.token).toBe('jwt');
    expect(result.user.id).toBe('user-1');
  });

  it('throws unauthorized for invalid credentials', async () => {
    const { service, authRepository } = createService();
    authRepository.login.mockRejectedValue(new InvalidCredentialsError());

    await expect(service.execute(email, password))
      .rejects
      .toBeInstanceOf(UnauthorizedException);
  });

  it('throws bad request for auth operation error', async () => {
    const { service, authRepository } = createService();
    authRepository.login.mockRejectedValue(new AuthOperationError('bad'));

    await expect(service.execute(email, password))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('throws bad request when user not found', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.login.mockResolvedValue({ token: 'jwt', userId: 'missing' });
    userRepository.findById.mockResolvedValue(null);

    await expect(service.execute(email, password))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('throws internal error for unexpected errors', async () => {
    const { service, authRepository } = createService();
    authRepository.login.mockRejectedValue(new Error('boom'));

    await expect(service.execute(email, password))
      .rejects
      .toBeInstanceOf(InternalServerErrorException);
  });
});
