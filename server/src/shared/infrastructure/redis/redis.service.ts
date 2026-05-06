import { Injectable, Logger, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis, { RedisOptions } from 'ioredis';
import { EnvironmentVariables } from '../../../config/environment.config';

@Injectable()
export class RedisService implements OnModuleInit, OnModuleDestroy {
  private readonly logger = new Logger(RedisService.name);
  private readonly client: Redis;

  constructor(private readonly configService: ConfigService<EnvironmentVariables, true>) {
    const redisUrl = this.configService.getOrThrow<string>('REDIS_URL');
    const options: RedisOptions = {
      enableAutoPipelining: true,
      lazyConnect: true,
      maxRetriesPerRequest: 3,
      connectTimeout: 10000,
      retryStrategy: (times) => Math.min(times * 100, 2000),
      tls: redisUrl.startsWith('rediss://') ? {} : undefined,
    };

    this.client = new Redis(redisUrl, options);

    this.client.on('error', (error) => {
      this.logger.error('Redis connection error', error instanceof Error ? error.stack : String(error));
    });

    this.client.on('connect', () => {
      this.logger.log('Redis connected');
    });
  }

  async onModuleInit(): Promise<void> {
    await this.client.connect();
  }

  async onModuleDestroy(): Promise<void> {
    await this.client.quit();
  }

  getClient(): Redis {
    return this.client;
  }
}
