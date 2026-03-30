import { Module } from "@nestjs/common";
import { UsersController } from "./user.controller";
import { UserRepository } from "../domain/repositories/user.repository";
import { CreateUserService } from "../application/services/create-user.service";
import { DrizzleUserRepository } from "../infrastructure/drizzle-user.repository";
import { DrizzleModule } from "../../../shared/infrastructure/database/drizzle.module";
import { FindUserService } from "../application/services/find-user.service";

@Module({
  imports: [DrizzleModule],
  controllers: [UsersController],
  providers: [
    CreateUserService,
    FindUserService,
    {
      provide: UserRepository,
      useClass: DrizzleUserRepository,
    },
  ],
})
export class UsersModule {}