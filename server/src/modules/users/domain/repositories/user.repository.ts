import { UserEntity } from '../entities/user.entity';

export type CreateUserInput = {
  email: string;
  fullName: string;
};

export abstract class UserRepository {
  abstract findById(id: string): Promise<UserEntity | null>;
  abstract create(input: CreateUserInput): Promise<UserEntity>;
}
