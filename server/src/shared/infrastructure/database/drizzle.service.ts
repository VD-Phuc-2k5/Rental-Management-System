import { Injectable, OnModuleDestroy } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { drizzle, NodePgDatabase } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import { EnvironmentVariables } from '../../../config/environment.config';
import * as schema from './schema/index';

@Injectable()
export class DrizzleService implements OnModuleDestroy {
  private readonly pool: Pool;
  public readonly db: NodePgDatabase<typeof schema>;

  constructor(private readonly configService: ConfigService<EnvironmentVariables, true>) {
    const databaseUrl = this.configService.getOrThrow<string>('DATABASE_URL');

    this.pool = new Pool({
      connectionString: databaseUrl,
    });

    this.db = drizzle(this.pool, { schema });
  }

  async onModuleDestroy(): Promise<void> {
    await this.pool.end();
  }
}
