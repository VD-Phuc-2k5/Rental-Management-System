export type EnvironmentVariables = {
  PORT?: string;
  SUPABASE_URL: string;
  SUPABASE_SERVICE_ROLE_KEY: string;
  DATABASE_URL: string;
};

export function validateEnvironment(config: Record<string, unknown>): EnvironmentVariables {
  const supabaseUrl = config.SUPABASE_URL;
  const supabaseServiceRoleKey = config.SUPABASE_SERVICE_ROLE_KEY;
  const databaseUrl = config.DATABASE_URL;

  if (typeof supabaseUrl !== 'string' || supabaseUrl.trim().length === 0) {
    throw new Error('SUPABASE_URL is required');
  }

  if (typeof supabaseServiceRoleKey !== 'string' || supabaseServiceRoleKey.trim().length === 0) {
    throw new Error('SUPABASE_SERVICE_ROLE_KEY is required');
  }

  const normalizedSupabaseKey = supabaseServiceRoleKey.trim();
  if (
    normalizedSupabaseKey.startsWith('sb_publishable_') ||
    normalizedSupabaseKey.startsWith('eyJ')
  ) {
    throw new Error(
      'SUPABASE_SERVICE_ROLE_KEY must be a service role key (secret), not publishable/anon key',
    );
  }

  if (typeof databaseUrl !== 'string' || databaseUrl.trim().length === 0) {
    throw new Error('DATABASE_URL is required');
  }

  return {
    PORT: typeof config.PORT === 'string' ? config.PORT : undefined,
    SUPABASE_URL: supabaseUrl,
    SUPABASE_SERVICE_ROLE_KEY: normalizedSupabaseKey,
    DATABASE_URL: databaseUrl,
  };
}
