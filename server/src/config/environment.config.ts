export type EnvironmentVariables = {
  PORT?: string;
  SUPABASE_URL: string;
  SUPABASE_SERVICE_ROLE_KEY: string;
  DATABASE_URL: string;
  REDIS_URL: string;
  SMTP_HOST: string;
  SMTP_PORT: string;
  SMTP_USER: string;
  SMTP_PASS: string;
  SMTP_FROM: string;
  SMTP_SECURE?: string;
  VNPAY_TMN_CODE: string;
  VNPAY_HASH_SECRET: string;
  VNPAY_BASE_URL: string;
  VNPAY_IPN_URL: string;
  VNPAY_RETURN_URL: string;
  PAYOS_CLIENT_ID?: string;
  PAYOS_API_KEY?: string;
  PAYOS_CHECKSUM_KEY?: string;
  PAYOS_RETURN_URL?: string;
  PAYOS_CANCEL_URL?: string;
};

export function validateEnvironment(
  config: Record<string, unknown>,
): EnvironmentVariables {
  const supabaseUrl = config.SUPABASE_URL;
  const supabaseServiceRoleKey = config.SUPABASE_SERVICE_ROLE_KEY;
  const databaseUrl = config.DATABASE_URL;
  const redisUrl = config.REDIS_URL;
  const smtpHost = config.SMTP_HOST;
  const smtpPort = config.SMTP_PORT;
  const smtpUser = config.SMTP_USER;
  const smtpPass = config.SMTP_PASS;
  const smtpFrom = config.SMTP_FROM;
  const smtpSecure = config.SMTP_SECURE;

  if (typeof supabaseUrl !== 'string' || supabaseUrl.trim().length === 0) {
    throw new Error('SUPABASE_URL is required');
  }

  if (
    typeof supabaseServiceRoleKey !== 'string' ||
    supabaseServiceRoleKey.trim().length === 0
  ) {
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

  if (typeof redisUrl !== 'string' || redisUrl.trim().length === 0) {
    throw new Error('REDIS_URL is required');
  }

  if (typeof smtpHost !== 'string' || smtpHost.trim().length === 0) {
    throw new Error('SMTP_HOST is required');
  }

  if (typeof smtpPort !== 'string' || smtpPort.trim().length === 0) {
    throw new Error('SMTP_PORT is required');
  }

  if (typeof smtpUser !== 'string' || smtpUser.trim().length === 0) {
    throw new Error('SMTP_USER is required');
  }

  if (typeof smtpPass !== 'string' || smtpPass.trim().length === 0) {
    throw new Error('SMTP_PASS is required');
  }

  if (typeof smtpFrom !== 'string' || smtpFrom.trim().length === 0) {
    throw new Error('SMTP_FROM is required');
  }

  return {
    PORT: typeof config.PORT === 'string' ? config.PORT : undefined,
    SUPABASE_URL: supabaseUrl,
    SUPABASE_SERVICE_ROLE_KEY: normalizedSupabaseKey,
    DATABASE_URL: databaseUrl,
    REDIS_URL: redisUrl,
    SMTP_HOST: smtpHost,
    SMTP_PORT: smtpPort,
    SMTP_USER: smtpUser,
    SMTP_PASS: smtpPass,
    SMTP_FROM: smtpFrom,
    SMTP_SECURE: typeof smtpSecure === 'string' ? smtpSecure : undefined,
    VNPAY_TMN_CODE: (config.VNPAY_TMN_CODE as string) ?? '',
    VNPAY_HASH_SECRET: (config.VNPAY_HASH_SECRET as string) ?? '',
    VNPAY_BASE_URL:
      (config.VNPAY_BASE_URL as string) ??
      'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
    VNPAY_IPN_URL: (config.VNPAY_IPN_URL as string) ?? '',
    VNPAY_RETURN_URL:
      (config.VNPAY_RETURN_URL as string) ?? 'app://vnpay-result',
    PAYOS_CLIENT_ID:
      typeof config.PAYOS_CLIENT_ID === 'string' ? config.PAYOS_CLIENT_ID : undefined,
    PAYOS_API_KEY:
      typeof config.PAYOS_API_KEY === 'string' ? config.PAYOS_API_KEY : undefined,
    PAYOS_CHECKSUM_KEY:
      typeof config.PAYOS_CHECKSUM_KEY === 'string' ? config.PAYOS_CHECKSUM_KEY : undefined,
    PAYOS_RETURN_URL:
      typeof config.PAYOS_RETURN_URL === 'string' ? config.PAYOS_RETURN_URL : undefined,
    PAYOS_CANCEL_URL:
      typeof config.PAYOS_CANCEL_URL === 'string' ? config.PAYOS_CANCEL_URL : undefined,
  };
}
