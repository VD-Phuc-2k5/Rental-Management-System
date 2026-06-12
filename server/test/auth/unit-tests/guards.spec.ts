import { ForbiddenException, UnauthorizedException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { AuthGuard } from '../../../src/shared/common/guards/auth.guard';
import { RolesGuard } from '../../../src/shared/common/guards/roles.guard';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

function mockSupabaseService(getUserResult: any) {
  return {
    getClient: jest.fn(() => ({
      auth: {
        getUser: jest.fn().mockResolvedValue(getUserResult),
      },
    })),
  };
}

function mockDrizzleService(user: any) {
  return {
    db: {
      query: {
        users: {
          findFirst: jest.fn().mockResolvedValue(user),
        },
      },
    },
  };
}

function mockExecutionContext(options: {
  headers?: Record<string, string>;
  user?: any;
}) {
  const request: any = { headers: options.headers ?? {}, user: options.user };
  return {
    switchToHttp: () => ({
      getRequest: () => request,
    }),
    getHandler: jest.fn(),
    getClass: jest.fn(),
  } as any;
}

// ---------------------------------------------------------------------------
// AuthGuard — token validation
// ---------------------------------------------------------------------------

describe('AuthGuard', () => {
  const validUser = {
    id: 'user-1',
    phone: '0912345678',
    fullName: 'Nguyen Van A',
    avatarUrl: null,
    roles: [{ role: 'tenant' }],
  };

  it('AUTH-048: rejects when no Authorization header', async () => {
    const supabase = mockSupabaseService({ data: null, error: null });
    const drizzle = mockDrizzleService(validUser);
    const guard = new AuthGuard(supabase as any, drizzle as any);
    const ctx = mockExecutionContext({ headers: {} });

    await expect(guard.canActivate(ctx)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('AUTH-049: rejects when Bearer token is empty', async () => {
    const supabase = mockSupabaseService({ data: null, error: null });
    const drizzle = mockDrizzleService(validUser);
    const guard = new AuthGuard(supabase as any, drizzle as any);
    const ctx = mockExecutionContext({ headers: { authorization: 'Bearer ' } });

    await expect(guard.canActivate(ctx)).rejects.toBeInstanceOf(UnauthorizedException);
  });

  it('AUTH-050: rejects when token is invalid (Supabase returns error)', async () => {
    const supabase = mockSupabaseService({
      data: { user: null },
      error: { message: 'Invalid token' },
    });
    const drizzle = mockDrizzleService(validUser);
    const guard = new AuthGuard(supabase as any, drizzle as any);
    const ctx = mockExecutionContext({ headers: { authorization: 'Bearer fake-jwt-token' } });

    await expect(guard.canActivate(ctx)).rejects.toBeInstanceOf(UnauthorizedException);
  });
});

// ---------------------------------------------------------------------------
// RolesGuard — role checking
// ---------------------------------------------------------------------------

describe('RolesGuard', () => {
  const mockReflector = (roles: string[] | undefined) => {
    const reflector = new Reflector();
    jest.spyOn(reflector, 'getAllAndOverride').mockReturnValue(roles);
    return reflector;
  };

  it('AUTH-051: allows when user has required role', () => {
    const reflector = mockReflector(['tenant']);
    const guard = new RolesGuard(reflector);
    const ctx = mockExecutionContext({
      headers: { authorization: 'Bearer valid-jwt-token' },
      user: { roles: ['tenant'] },
    });

    expect(guard.canActivate(ctx)).toBe(true);
  });

  it('AUTH-052: forbids when user lacks required role', () => {
    const reflector = mockReflector(['admin']);
    const guard = new RolesGuard(reflector);
    const ctx = mockExecutionContext({
      headers: { authorization: 'Bearer valid-jwt-token' },
      user: { roles: ['tenant'] },
    });

    expect(() => guard.canActivate(ctx)).toThrow(ForbiddenException);
  });
});
