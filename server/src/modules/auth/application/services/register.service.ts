import { Inject, Injectable } from '@nestjs/common';
import {
  AuthRepository,
  RegisterAuthInput,
} from '../../domain/repositories/auth.repository';
import { RegisterDto } from '../dto/register.dto';

@Injectable()
export class RegisterService {
  constructor(
    @Inject(AuthRepository)
    private readonly authRepository: AuthRepository,
  ) {}

  async execute(input: RegisterDto) {
    const authInput: RegisterAuthInput = {
      email: input.email,
      password: input.password,
      phone: input.phone,
      fullName: input.fullName,
      avatarUrl: input.avatarUrl,
    };

    const authUser = await this.authRepository.register(authInput);

    return {
      id: authUser.id,
      email: authUser.email,
      profile: {
        phone: input.phone,
        fullName: input.fullName,
        avatarUrl: input.avatarUrl ?? null,
      },
    };
  }
}
