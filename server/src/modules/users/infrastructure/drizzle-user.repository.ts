import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from '../../../shared/infrastructure/database/drizzle.service';
import { userRoles, users } from '../../../shared/infrastructure/database/schema/index';
import { UserEntity } from '../domain/entities/user.entity';
import { CreateUserInput, UserRepository } from '../domain/repositories/user.repository';

@Injectable()
export class DrizzleUserRepository implements UserRepository {
    constructor(private readonly drizzleService: DrizzleService) {}

    async findById(id: string): Promise<UserEntity | null> {
        const row = await this.drizzleService.db.query.users
            .findFirst({
                where: eq(users.id, id),
                with: {
                    roles: {
                        columns: {
                            role: true,
                        }
                    }
                }
            })

        if (!row) {
            return null;
        }

        return new UserEntity(
            row.id,
            row.phone,
            row.fullName,
            row.avatarUrl,
            row.roles.map((r) => r.role),
            row.createdAt.toISOString(),
            row.updatedAt.toISOString(),
        );
    }

    async create(input: CreateUserInput): Promise<UserEntity> {
        const row = await this.drizzleService.db.transaction(async (tx) => {
            const [user] = await tx.insert(users).values(
                {
                    id: input.id,
                    fullName: input.fullName,
                    phone: input.phone,
                    avatarUrl: input.avatarUrl,
                }
            ).returning();

            await tx.insert(userRoles).values({
                userId: user.id,
                role: "tenant"
            });

            return user;
        });

        return new UserEntity(
            row.id,
            row.phone,
            row.fullName,
            row.avatarUrl,
            ['tenant'],
            row.createdAt.toISOString(),
            row.updatedAt.toISOString(),
        );

    }

    async createWithDefaultRole(input: CreateUserInput): Promise<UserEntity> {
        const row = await this.drizzleService.db.transaction(async (tx) => {
            const [insertedUser] = await tx
                .insert(users)
                .values({
                    id: input.id,
                    phone: input.phone,
                    fullName: input.fullName,
                    avatarUrl: input.avatarUrl,
                })
                .onConflictDoNothing()
                .returning();

            const createdUser =
                insertedUser ??
                (await tx.query.users.findFirst({
                    where: eq(users.id, input.id),
                }));

            if (!createdUser) {
                throw new Error('Không tìm thấy thông tin người dùng sau khi tạo tài khoản');
            }

            await tx.insert(userRoles).values({
                userId: createdUser.id,
                role: 'tenant',
            }).onConflictDoNothing();

            return createdUser;
        });

        return new UserEntity(
            row.id,
            row.phone,
            row.fullName,
            row.avatarUrl,
            ['tenant'],
            row.createdAt.toISOString(),
            row.updatedAt.toISOString(),
        );
    }
}