export type RegisterAuthInput = {
  email: string;
  password: string;
  phone: string;
  fullName: string;
  avatarUrl?: string;
};

export type RegisteredAuthUser = {
  id: string;
  email: string;
};

export abstract class AuthRepository {
  abstract register(input: RegisterAuthInput): Promise<RegisteredAuthUser>;
}
