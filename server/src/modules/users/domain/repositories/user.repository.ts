import { UserEntity } from '../entities/user.entity';

export type CreateUserInput = {
  id: string;
  phone: string;
  fullName: string;
  avatarUrl?: string;
};

export abstract class UserRepository {
  abstract findById(id: string): Promise<UserEntity | null>;
  abstract create(input: CreateUserInput): Promise<UserEntity>;
  abstract createWithDefaultRole(input: CreateUserInput): Promise<UserEntity>;
}
