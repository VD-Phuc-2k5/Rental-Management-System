import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { validateEnvironment } from './config/environment.config';
import { UsersModule } from './modules/users/presentation/user.module';
import { AuthModule } from './modules/auth/presentation/auth.module';
import { DrizzleModule } from './shared/infrastructure/database/drizzle.module';
import { SupabaseModule } from './shared/infrastructure/supabase/supabase.module';
import { PropertiesModule } from './modules/properties/presentation/properties.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      cache: true,
      envFilePath: ['.env.local', '.env'],
      validate: validateEnvironment,
    }),
    SupabaseModule,
    DrizzleModule,
    UsersModule,
    AuthModule,
    PropertiesModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
