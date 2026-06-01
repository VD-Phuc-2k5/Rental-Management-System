import { PenaltiesModule } from './modules/penalties/penalties.module';
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
import { RedisModule } from './shared/infrastructure/redis/redis.module';
import { RoomsModule } from './modules/rooms/presentation/room.module';
import { RentalRequestsModule } from './modules/rental-requests/presentation/rental-request.module';
import { ViewingAppointmentsModule } from './modules/viewing-appointments/presentation/viewing-appointment.module';
import { UploadModule } from './modules/upload/upload.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { BillingModule } from './modules/billing/billing.module';
import { MaintenanceRequestsModule } from './modules/maintenance-requests/presentation/maintenance-request.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      cache: true,
      envFilePath: ['.env.local', '.env'],
      validate: validateEnvironment,
    }),
    SupabaseModule,
    RedisModule,
    DrizzleModule,
    UsersModule,
    AuthModule,
    PropertiesModule,
    RoomsModule,
    RentalRequestsModule,
    ViewingAppointmentsModule,
    UploadModule,
    PaymentsModule,
    PenaltiesModule,
    BillingModule,
    MaintenanceRequestsModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
