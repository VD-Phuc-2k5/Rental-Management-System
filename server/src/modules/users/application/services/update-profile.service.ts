import { Inject, Injectable, NotFoundException } from '@nestjs/common';
import {
  UserRepository,
  UpdateProfileInput,
} from '../../domain/repositories/user.repository';
import { UserEntity } from '../../domain/entities/user.entity';

@Injectable()
export class UpdateProfileService {
  constructor(
    @Inject(UserRepository)
    private readonly userRepository: UserRepository,
  ) {}

  async execute(
    userId: string,
    input: UpdateProfileInput,
  ): Promise<UserEntity> {
    const existing = await this.userRepository.findById(userId);
    if (!existing) {
      throw new NotFoundException('User not found');
    }
    return this.userRepository.updateProfile(userId, input);
  }
}
