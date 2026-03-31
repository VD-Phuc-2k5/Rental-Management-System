import {
  Injectable,
} from '@nestjs/common';
import {
  AuthRepository,
  RegisterAuthInput,
  RegisteredAuthUser,
} from '../domain/repositories/auth.repository';
import { SupabaseService } from '../../../shared/infrastructure/supabase/supabase.service';
import {
  AuthOperationError,
  DuplicateEmailError,
  InvalidCredentialsError,
} from '../domain/errors/auth.errors';

@Injectable()
export class SupabaseAuthRepository implements AuthRepository {
  constructor(private readonly supabaseService: SupabaseService) {}

  async register(input: RegisterAuthInput): Promise<RegisteredAuthUser> {
    try {
      const { data, error } = await this.supabaseService.getClient().auth.admin.createUser({
        email: input.email,
        password: input.password,
        email_confirm: true,
        user_metadata: {
          phone: input.phone,
          fullName: input.fullName,
          avatarUrl: input.avatarUrl,
        },
      });

      if (error || !data.user) {
        const errorMessage = error?.message?.toLowerCase() ?? '';
        const isDuplicatedEmailError =
          errorMessage.includes('already been registered') ||
          errorMessage.includes('already registered') ||
          errorMessage.includes('already exists') ||
          errorMessage.includes('duplicate') ||
          errorMessage.includes('email address has already');

        if (isDuplicatedEmailError) {
          throw new DuplicateEmailError();
        }

        throw new AuthOperationError(error?.message ?? 'Đăng ký thất bại');
      }

      return {
        id: data.user.id,
        email: data.user.email ?? input.email,
      };
    } catch (error) {
      if (error instanceof DuplicateEmailError || error instanceof AuthOperationError) {
        throw error;
      }

      throw new AuthOperationError('Lỗi hệ thống khi đăng ký');
    }
  }

  async deleteUser(userId: string): Promise<void> {
    const { error } = await this.supabaseService.getClient().auth.admin.deleteUser(userId);

    if (error) {
      throw new AuthOperationError('Không thể hoàn tác người dùng đã tạo');
    }
  }

  async login(email: string, password: string): Promise<{ token: string, userId: string}> {
    try {
      const { data, error } = await this.supabaseService.getClient().auth.signInWithPassword({
        email,
        password,
      });

      if (error || !data.session) {
        const errorMessage = error?.message?.toLowerCase() ?? '';
        const isInvalidCredentialError =
          error?.status === 400 || errorMessage.includes('invalid login credentials');

        if (isInvalidCredentialError) {
          throw new InvalidCredentialsError();
        }

        throw new AuthOperationError(error?.message ?? 'Đăng nhập thất bại');
      }

      return {
        token: data.session.access_token,
        userId: data.user.id,
      }
    } catch (error) {
      if (error instanceof InvalidCredentialsError || error instanceof AuthOperationError) {
        throw error;
      }

      throw new AuthOperationError('Lỗi hệ thống khi đăng nhập');
    }
  }
}
