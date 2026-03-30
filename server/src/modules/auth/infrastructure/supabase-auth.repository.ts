import {
  BadRequestException,
  Injectable,
  InternalServerErrorException,
  UnauthorizedException,
} from '@nestjs/common';
import {
  AuthRepository,
  RegisterAuthInput,
  RegisteredAuthUser,
} from '../domain/repositories/auth.repository';
import { SupabaseService } from '../../../shared/infrastructure/supabase/supabase.service';

@Injectable()
export class SupabaseAuthRepository implements AuthRepository {
  constructor(private readonly supabaseService: SupabaseService) {}

  async register(input: RegisterAuthInput): Promise<RegisteredAuthUser> {
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
      throw new BadRequestException(error?.message ?? 'Đăng ký thất bại');
    }

    return {
      id: data.user.id,
      email: data.user.email ?? input.email,
    };
  }

  async login(email: string, password: string): Promise<{ token: string }> {
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
          throw new UnauthorizedException('Email hoặc mật khẩu không đúng');
        }

        throw new BadRequestException(error?.message ?? 'Đăng nhập thất bại');
      }

      return {
        token: data.session.access_token,
      };
    } catch (error) {
      if (error instanceof UnauthorizedException || error instanceof BadRequestException) {
        throw error;
      }

      throw new InternalServerErrorException('Lỗi hệ thống khi đăng nhập');
    }
  }
}
