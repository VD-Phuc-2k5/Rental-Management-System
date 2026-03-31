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


@Injectable()
export class LoginService {
  constructor(
    @Inject(AuthRepository)
    private readonly authRepository: AuthRepository,
  ) {}

  async execute(email: string, password: string) {
    try {
      const token = await this.authRepository.login(email, password);

      return { token };
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