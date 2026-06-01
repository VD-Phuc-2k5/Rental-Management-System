import { Module } from "@nestjs/common";
import { DrizzleModule } from "../../../shared/infrastructure/database/drizzle.module";
import { PropertiesController } from "./properties.controller";
import { DrizzlePropertiesRepository } from "../infrastructure/drizzle-properties.repository";
import { PropertiesRepository } from "../domain/repositories/properties.repository";
import { CreatePropertiesService } from "../application/services/create-properties.service";
import { GetPropertiesService } from "../application/services/get-properties.service";
import { GetPropertyByIdService } from "../application/services/get-property-by-id.service";
import { UpdatePropertiesService } from "../application/services/update-properties.service";
import { DeletePropertiesService } from "../application/services/delete-properties.service";
import { SupabaseModule } from "src/shared/infrastructure/supabase/supabase.module";
import { AuthGuard } from "src/shared/common/guards/auth.guard";
import { RolesGuard } from "src/shared/common/guards/roles.guard";

@Module({
    imports: [DrizzleModule, SupabaseModule],
    controllers: [PropertiesController],
    providers: [
        CreatePropertiesService,
        GetPropertiesService,
        GetPropertyByIdService,
        UpdatePropertiesService,
        DeletePropertiesService,
        AuthGuard,
        RolesGuard,
        { provide: PropertiesRepository, useClass: DrizzlePropertiesRepository },
    ],
    exports: [PropertiesRepository],
})
export class PropertiesModule {}
