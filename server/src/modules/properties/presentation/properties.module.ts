import { Module } from "@nestjs/common";
import { DrizzleModule } from "../../../shared/infrastructure/database/drizzle.module";
import { PropertiesController } from "./properties.controller";
import { DrizzlePropertiesRepository } from "../infrastructure/drizzle-properties.repository";
import { PropertiesRepository } from "../domain/repositories/properties.repository";
import { CreatePropertiesService } from "../application/services/create-properties.service";
import { SupabaseModule } from "src/shared/infrastructure/supabase/supabase.module";
import { AuthGuard } from "src/shared/common/guards/auth.guard";
import { RolesGuard } from "src/shared/common/guards/roles.guard";

@Module({
  imports: [DrizzleModule, SupabaseModule],
  controllers: [PropertiesController],
  providers: [
    CreatePropertiesService,
    AuthGuard,
    RolesGuard,
    {
      provide: PropertiesRepository,
      useClass: DrizzlePropertiesRepository,
    },
  ],
  exports: [PropertiesRepository],
})
export class PropertiesModule {}