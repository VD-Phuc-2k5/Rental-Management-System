export type RegisterAuthInput = {
  email: string;
  password: string;
  confirmPassword: string;
  phone: string | null;
  fullName: string;
  avatarUrl?: string;
  acceptTerms: boolean;
};

export type RegisteredAuthUser = {
  id: string;
  email: string;
};

export abstract class AuthRepository {
  abstract register(input: RegisterAuthInput): Promise<RegisteredAuthUser>;
  abstract deleteUser(userId: string): Promise<void>;
  abstract login(email: string, password: string): Promise<{ token: string, userId: string }>;
  abstract findUserIdByEmail(email: string): Promise<string | null>;
  abstract updatePassword(userId: string, password: string): Promise<void>;
}
