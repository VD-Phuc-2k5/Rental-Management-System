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

  if (typeof databaseUrl !== 'string' || databaseUrl.trim().length === 0) {
    throw new Error('DATABASE_URL is required');
  }

  return {
    PORT: typeof config.PORT === 'string' ? config.PORT : undefined,
    SUPABASE_URL: supabaseUrl,
    SUPABASE_SERVICE_ROLE_KEY: supabaseServiceRoleKey,
    DATABASE_URL: databaseUrl,
  };
}
