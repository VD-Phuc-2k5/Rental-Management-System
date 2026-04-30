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

@Injectable()
export class RegisterService {
  private readonly logger = new Logger(RegisterService.name);

  constructor(
    @Inject(AuthRepository)
    private readonly authRepository: AuthRepository,
    @Inject(UserRepository)
    private readonly userRepository: UserRepository,
  ) {}

  async execute(input: RegisterDto) {
    let createdAuthUserId: string | null = null;

    try {
      const authInput: RegisterAuthInput = {
        email: input.email,
        password: input.password,
        confirmPassword: input.confirm_password,
        phone: input.phone,
        fullName: input.fullName,
        avatarUrl: input.avatarUrl,
        acceptTerms: input.accepted_terms,
      };

      const authUser = await this.authRepository.register(authInput);
      createdAuthUserId = authUser.id;

      const profile = await this.userRepository.createWithDefaultRole({
        id: authUser.id,
        phone: input.phone,
        fullName: input.fullName,
        avatarUrl: input.avatarUrl,
      });

      return {
        id: authUser.id,
        email: authUser.email,
        profile: {
          phone: profile.phone,
          fullName: profile.fullName,
          avatarUrl: profile.avatarUrl,
        },
        role: 'tenant',
      };
    } catch (error) {
      this.logger.error(
        'Register flow failed',
        error instanceof Error ? error.stack : String(error),
      );

      if (error instanceof DuplicateEmailError) {
        throw new ConflictException(error.message);
      }

      if (error instanceof AuthOperationError) {
        throw new BadRequestException(error.message);
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

      throw new InternalServerErrorException('Lỗi hệ thống khi đăng ký');
    }
  }
}
