import { Inject, Injectable } from '@nestjs/common';
import {
  AuthRepository,
  RegisterAuthInput,
} from '../../domain/repositories/auth.repository';
import { RegisterDto } from '../dto/register.dto';
import { UserRepository } from '../../../users/domain/repositories/user.repository';

@Injectable()
export class RegisterService {
  constructor(
    @Inject(AuthRepository)
    private readonly authRepository: AuthRepository,
    @Inject(UserRepository)
    private readonly userRepository: UserRepository,
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
  }
}
