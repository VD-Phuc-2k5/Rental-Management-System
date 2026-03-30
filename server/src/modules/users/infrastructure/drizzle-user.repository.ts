import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from '../../../shared/infrastructure/database/drizzle.service';
import { users } from '../../../shared/infrastructure/database/schema/index';
import { UserEntity } from '../domain/entities/user.entity';
import { CreateUserInput, UserRepository } from '../domain/repositories/user.repository';

@Injectable()
export class DrizzleUserRepository implements UserRepository {
    constructor(private readonly drizzleService: DrizzleService) {}

    async findById(id: string): Promise<UserEntity | null> {
        const row = await this.drizzleService.db.query.users.findFirst({
            where: eq(users.id, id),
        });

        if (!row) {
            return null;
    }

        return new UserEntity(
            row.id,
            row.phone,
            row.fullName,
            row.avatarUrl,
            row.createdAt.toISOString(),
            row.updatedAt.toISOString(),
        );
    }

    async create(input: CreateUserInput): Promise<UserEntity> {
        const [row] = await this.drizzleService.db
            .insert(users)
            .values({
                id: input.id,
                phone: input.phone,
                fullName: input.fullName,
                avatarUrl: input.avatarUrl,
            })
            .returning();

        return new UserEntity(
            row.id,
            row.phone,
            row.fullName,
            row.avatarUrl,
            row.createdAt.toISOString(),
            row.updatedAt.toISOString(),
        );
    }
}