import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { users } from 'src/shared/infrastructure/database/schema';
import { SupabaseService } from 'src/shared/infrastructure/supabase/supabase.service';
import { AuthenticatedRequest } from '../auth/authenticated-request.interface';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(
    private readonly supabaseService: SupabaseService,
    private readonly drizzleService: DrizzleService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<AuthenticatedRequest>();
    const authorizationHeader = request.headers.authorization;

    if (!authorizationHeader?.startsWith('Bearer ')) {
      throw new UnauthorizedException('Thiếu hoặc không hợp lệ header Authorization');
    }

    const token = authorizationHeader.slice(7).trim();
    if (!token) {
      throw new UnauthorizedException('Thiếu access token');
    }

    const { data, error } = await this.supabaseService.getClient().auth.getUser(token);
    if (error || !data.user) {
      throw new UnauthorizedException('Access token không hợp lệ hoặc đã hết hạn');
    }

    const localUser = await this.drizzleService.db.query.users.findFirst({
      where: eq(users.id, data.user.id),
      with: {
        roles: {
          columns: { role: true },
        },
      },
    });

    if (!localUser) {
      throw new UnauthorizedException('Người dùng không tồn tại trong hệ thống');
    }

    request.user = {
      id: localUser.id,
      email: data.user.email ?? '',
      phone: localUser.phone,
      full_name: localUser.fullName,
      avartar_url: localUser.avatarUrl,
      roles: localUser.roles.map((item) => item.role),
    };

    return true;
  }
}
