import {
  BadRequestException,
  ConflictException,
  InternalServerErrorException,
} from '@nestjs/common';
import { RegisterService } from '../../../src/modules/auth/application/services/register.service';
import {
  AuthOperationError,
  DuplicateEmailError,
} from '../../../src/modules/auth/domain/errors/auth.errors';
import { AuthRepository } from '../../../src/modules/auth/domain/repositories/auth.repository';
import { UserRepository } from '../../../src/modules/users/domain/repositories/user.repository';
import { RegisterDto } from '../../../src/modules/auth/application/dto/register.dto';

const baseInput: RegisterDto = {
  email: 'tenant@test.com',
  fullName: 'Nguyen Van A',
  phone: '0912345678',
  password: 'Test@1234',
  confirm_password: 'Test@1234',
  accepted_terms: true,
};

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

  const service = new RegisterService(authRepository, userRepository);
  return { service, authRepository, userRepository };
}

describe('RegisterService', () => {
  it('registers tenant successfully', async () => {
    const { service, authRepository, userRepository } = createService();

    authRepository.findUserIdByEmail.mockResolvedValue(null);
    userRepository.findByPhone.mockResolvedValue(null);
    userRepository.findByIdentityNumber.mockResolvedValue(null);
    authRepository.register.mockResolvedValue({ id: 'user-1', email: baseInput.email });
    userRepository.create.mockResolvedValue({
      id: 'user-1',
      phone: baseInput.phone,
      identityNumber: null,
      fullName: baseInput.fullName,
      avatarUrl: null,
      role: ['tenant'],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      acceptedTerms: true,
      dateOfBirth: null,
    });

    const result = await service.execute({ ...baseInput });

    expect(result).toEqual({
      id: 'user-1',
      email: baseInput.email,
      profile: {
        phone: baseInput.phone,
        identityNumber: null,
        fullName: baseInput.fullName,
        avatarUrl: null,
      },
      role: 'tenant',
    });
    expect(authRepository.register).toHaveBeenCalled();
    expect(userRepository.create).toHaveBeenCalled();
  });

  it('throws conflict when email already exists', async () => {
    const { service, authRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue('existing-id');

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(ConflictException);
  });

  it('throws conflict when phone already exists', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    userRepository.findByPhone.mockResolvedValue({} as any);

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(ConflictException);
  });

  it('throws conflict when identity number already exists', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    userRepository.findByPhone.mockResolvedValue(null);
    userRepository.findByIdentityNumber.mockResolvedValue({} as any);

    await expect(
      service.execute({ ...baseInput, identity_number: '123456789012' }),
    ).rejects.toBeInstanceOf(ConflictException);
  });

  it('maps DuplicateEmailError to conflict', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    userRepository.findByPhone.mockResolvedValue(null);
    userRepository.findByIdentityNumber.mockResolvedValue(null);
    authRepository.register.mockRejectedValue(new DuplicateEmailError());

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(ConflictException);
  });

  it('maps AuthOperationError to bad request', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    userRepository.findByPhone.mockResolvedValue(null);
    userRepository.findByIdentityNumber.mockResolvedValue(null);
    authRepository.register.mockRejectedValue(new AuthOperationError('bad'));

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });

  it('rolls back auth user when profile creation fails', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    userRepository.findByPhone.mockResolvedValue(null);
    userRepository.findByIdentityNumber.mockResolvedValue(null);
    authRepository.register.mockResolvedValue({ id: 'user-1', email: baseInput.email });
    userRepository.create.mockRejectedValue(new Error('db error'));
    authRepository.deleteUser.mockResolvedValue();

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(InternalServerErrorException);

    expect(authRepository.deleteUser).toHaveBeenCalledWith('user-1');
  });

  it('fails when rollback fails', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    userRepository.findByPhone.mockResolvedValue(null);
    userRepository.findByIdentityNumber.mockResolvedValue(null);
    authRepository.register.mockResolvedValue({ id: 'user-1', email: baseInput.email });
    userRepository.create.mockRejectedValue(new Error('db error'));
    authRepository.deleteUser.mockRejectedValue(new Error('rollback error'));

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(InternalServerErrorException);
  });

  it('skips phone check when phone is not provided', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    authRepository.register.mockResolvedValue({ id: 'user-1', email: baseInput.email });
    userRepository.create.mockResolvedValue({
      id: 'user-1',
      phone: null,
      identityNumber: null,
      fullName: baseInput.fullName,
      avatarUrl: null,
      role: ['tenant'],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      acceptedTerms: true,
      dateOfBirth: null,
    });

    const result = await service.execute({ ...baseInput, phone: null });

    expect(userRepository.findByPhone).not.toHaveBeenCalled();
    expect(result.profile.phone).toBeNull();
  });

  it('skips identity number check when not provided', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    userRepository.findByPhone.mockResolvedValue(null);
    authRepository.register.mockResolvedValue({ id: 'user-1', email: baseInput.email });
    userRepository.create.mockResolvedValue({
      id: 'user-1',
      phone: baseInput.phone,
      identityNumber: null,
      fullName: baseInput.fullName,
      avatarUrl: null,
      role: ['tenant'],
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
      acceptedTerms: true,
      dateOfBirth: null,
    });

    const result = await service.execute({ ...baseInput, identity_number: undefined });

    expect(userRepository.findByIdentityNumber).not.toHaveBeenCalled();
    expect(result.profile.identityNumber).toBeNull();
  });

  it('re-throws BadRequestException from create', async () => {
    const { service, authRepository, userRepository } = createService();
    authRepository.findUserIdByEmail.mockResolvedValue(null);
    userRepository.findByPhone.mockResolvedValue(null);
    userRepository.findByIdentityNumber.mockResolvedValue(null);
    authRepository.register.mockResolvedValue({ id: 'user-1', email: baseInput.email });
    userRepository.create.mockRejectedValue(new BadRequestException('validation error'));

    await expect(service.execute({ ...baseInput }))
      .rejects
      .toBeInstanceOf(BadRequestException);
  });
});
