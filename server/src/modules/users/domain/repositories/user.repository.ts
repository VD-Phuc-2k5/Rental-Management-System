import { UserEntity } from '../entities/user.entity';

export type CreateUserInput = {
  id: string;
  phone: string | null;
  identityNumber?: string | null;
  fullName: string;
  avatarUrl?: string;
};

export type UpdateProfileInput = {
  fullName?: string;
  phone?: string;
  avatarUrl?: string;
  dateOfBirth?: string;
};

export abstract class UserRepository {
  abstract findById(id: string): Promise<UserEntity | null>;
  abstract findByPhone(phone: string): Promise<UserEntity | null>;
  abstract findByIdentityNumber(
    identityNumber: string,
  ): Promise<UserEntity | null>;
  abstract create(input: CreateUserInput, role?: string): Promise<UserEntity>;
  abstract updateProfile(
    id: string,
    input: UpdateProfileInput,
  ): Promise<UserEntity>;
}
