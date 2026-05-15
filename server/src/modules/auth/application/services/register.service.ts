import {
  BadRequestException,
  ConflictException,
  Inject,
  Injectable,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import {
  AuthRepository,
  RegisterAuthInput,
} from '../../domain/repositories/auth.repository';
import { RegisterDto } from '../dto/register.dto';
import { UserRepository } from '../../../users/domain/repositories/user.repository';
import {
  AuthOperationError,
  DuplicateEmailError,
} from '../../domain/errors/auth.errors';
import { UserEntity } from 'src/modules/users/domain/entities/user.entity';

@Injectable()
export class RegisterService {
  private readonly logger = new Logger(RegisterService.name);

  constructor(
    @Inject(AuthRepository)
    private readonly authRepository: AuthRepository,
    @Inject(UserRepository)
    private readonly userRepository: UserRepository,
  ) {}

  async execute(input: RegisterDto, role: RoleType = 'tenant') {
    let createdAuthUserId: string | null = null;

    try {
      const existingAuthUserId = await this.authRepository.findUserIdByEmail(input.email);
      if (existingAuthUserId) {
        throw new ConflictException('Email đã được đăng ký');
      }

      const normalizedPhone = input.phone?.trim();
      if (normalizedPhone) {
        const existingPhoneUser = await this.userRepository.findByPhone(normalizedPhone);
        if (existingPhoneUser) {
          throw new ConflictException('Số điện thoại đã được đăng ký');
        }
      }

      const normalizedIdentityNumber = input.identity_number?.trim();
      if (normalizedIdentityNumber) {
        const existingIdentityUser = await this.userRepository.findByIdentityNumber(normalizedIdentityNumber);
        if (existingIdentityUser) {
          throw new ConflictException('CCCD đã được đăng ký');
        }
      }

      const authInput: RegisterAuthInput = {
        email: input.email,
        password: input.password,
        confirmPassword: input.confirm_password,
        phone: normalizedPhone ?? null,
        identity_number: normalizedIdentityNumber ?? null,
        fullName: input.fullName,
        avatarUrl: input.avatarUrl,
        acceptTerms: input.accepted_terms,
      };

      const authUser = await this.authRepository.register(authInput);
      createdAuthUserId = authUser.id;

      let profile: UserEntity = await this.userRepository.create(
        {
          id: authUser.id,
          phone: normalizedPhone ?? null,
          identityNumber: normalizedIdentityNumber ?? null,
          fullName: input.fullName,
          avatarUrl: input.avatarUrl,
        },
        role,
      );

      return {
        id: authUser.id,
        email: authUser.email,
        profile: {
          phone: profile.phone,
          identityNumber: profile.identityNumber,
          fullName: profile.fullName,
          avatarUrl: profile.avatarUrl,
        },
        role: role,
      };
    } catch (error: any ) {
      this.logger.error(
        'Register flow failed',
        error instanceof Error ? error.stack : String(error),
      );

      if (error instanceof ConflictException) {
        throw error;
      }

      if (error instanceof DuplicateEmailError) {
        throw new ConflictException(error.message);
      }

      if (error instanceof AuthOperationError) {
        throw new BadRequestException(error.message);
      }

      if (error instanceof BadRequestException) {
        throw error;
      }

      if (createdAuthUserId) {
        try {
          await this.authRepository.deleteUser(createdAuthUserId);
        } catch {
          throw new InternalServerErrorException(
            'Đăng ký không hoàn tất và không thể tự động hoàn tác dữ liệu',
          );
        }
      }

      console.dir(
    {
        message: error?.message,
        detail: error?.detail,
        code: error?.code,
        constraint: error?.constraint,
        table: error?.table,
        column: error?.column,
        stack: error?.stack,
        cause: error?.cause,
      },
    { depth: null },
  );

      throw new InternalServerErrorException('Lỗi hệ thống khi đăng ký');
    }
  }
}
