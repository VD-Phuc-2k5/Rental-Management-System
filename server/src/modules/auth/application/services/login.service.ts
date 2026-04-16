import {
  BadRequestException,
  Inject,
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthRepository } from '../../domain/repositories/auth.repository';
import {
  AuthOperationError,
  InvalidCredentialsError,
} from '../../domain/errors/auth.errors';
import { UserRepository } from '../../../users/domain/repositories/user.repository';


@Injectable()
export class LoginService {
  constructor(
    @Inject(AuthRepository)
    private readonly authRepository: AuthRepository,
    @Inject(UserRepository)
    private readonly userRepository: UserRepository,
  ) {}

  async execute(email: string, password: string) {
    try {
      const token = await this.authRepository.login(email, password);
      const user = await this.userRepository.findById(token.userId);

      if (!user) {
        throw new AuthOperationError('Người dùng không tồn tại');
      }

      return { token: token.token, user };
    } catch (error) {
      if (error instanceof InvalidCredentialsError) {
        throw new UnauthorizedException(error.message);
      }

      if (error instanceof AuthOperationError) {
        throw new BadRequestException(error.message);
      }

      throw new InternalServerErrorException('Lỗi hệ thống khi đăng nhập');
    }
  }
}