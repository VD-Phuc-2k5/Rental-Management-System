import { BadRequestException, Injectable } from '@nestjs/common';
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
}
