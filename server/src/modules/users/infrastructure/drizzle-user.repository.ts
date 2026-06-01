import { Injectable } from '@nestjs/common';
import { eq } from 'drizzle-orm';
import { DrizzleService } from '../../../shared/infrastructure/database/drizzle.service';
import {
  userRoles,
  users,
} from '../../../shared/infrastructure/database/schema/index';
import { UserEntity } from '../domain/entities/user.entity';
import {
  CreateUserInput,
  UpdateProfileInput,
  UserRepository,
} from '../domain/repositories/user.repository';

@Injectable()
export class DrizzleUserRepository implements UserRepository {
  constructor(private readonly drizzleService: DrizzleService) {}

  async findById(id: string): Promise<UserEntity | null> {
    const row = await this.drizzleService.db.query.users.findFirst({
      where: eq(users.id, id),
      with: {
        roles: {
          columns: {
            role: true,
          },
        },
      },
    });

    if (!row) {
      return null;
    }

    return new UserEntity(
      row.id,
      row.phone,
      row.identityNumber,
      row.fullName,
      row.avatarUrl,
      row.roles.map((r) => r.role),
      row.createdAt.toISOString(),
      row.updatedAt.toISOString(),
      row.acceptedTerms,
      row.dateOfBirth ?? null,
    );
  }

  async findByPhone(phone: string): Promise<UserEntity | null> {
    const row = await this.drizzleService.db.query.users.findFirst({
      where: eq(users.phone, phone),
      with: {
        roles: {
          columns: {
            role: true,
          },
        },
      },
    });

    if (!row) {
      return null;
    }

    return new UserEntity(
      row.id,
      row.phone,
      row.identityNumber,
      row.fullName,
      row.avatarUrl,
      row.roles.map((r) => r.role),
      row.createdAt.toISOString(),
      row.updatedAt.toISOString(),
      row.acceptedTerms,
      row.dateOfBirth ?? null,
    );
  }

  async findByIdentityNumber(
    identityNumber: string,
  ): Promise<UserEntity | null> {
    const row = await this.drizzleService.db.query.users.findFirst({
      where: eq(users.identityNumber, identityNumber),
      with: {
        roles: {
          columns: {
            role: true,
          },
        },
      },
    });

    if (!row) {
      return null;
    }

    return new UserEntity(
      row.id,
      row.phone,
      row.identityNumber,
      row.fullName,
      row.avatarUrl,
      row.roles.map((r) => r.role),
      row.createdAt.toISOString(),
      row.updatedAt.toISOString(),
      row.acceptedTerms,
      row.dateOfBirth ?? null,
    );
  }

  async create(
    input: CreateUserInput,
    role = 'tenant' as RoleType,
  ): Promise<UserEntity> {
    const row = await this.drizzleService.db.transaction(async (tx) => {
      const [insertedUser] = await tx
        .insert(users)
        .values({
          id: input.id,
          phone: input.phone,
          fullName: input.fullName,
          avatarUrl: input.avatarUrl,
          identityNumber: input.identityNumber,
        })
        .onConflictDoNothing()
        .returning();

      const createdUser =
        insertedUser ??
        (await tx.query.users.findFirst({
          where: eq(users.id, input.id),
        }));

      if (!createdUser) {
        throw new Error(
          'Không tìm thấy thông tin người dùng sau khi tạo tài khoản',
        );
      }

      await tx
        .insert(userRoles)
        .values({
          userId: createdUser.id,
          role: role,
        })
        .onConflictDoNothing();

      return createdUser;
    });

    return new UserEntity(
      row.id,
      row.phone,
      row.identityNumber,
      row.fullName,
      row.avatarUrl,
      [role],
      row.createdAt.toISOString(),
      row.updatedAt.toISOString(),
      row.acceptedTerms,
      row.dateOfBirth ?? null,
    );
  }

  async updateProfile(
    id: string,
    input: UpdateProfileInput,
  ): Promise<UserEntity> {
    const updateData: Partial<typeof users.$inferInsert> = {};
    if (input.fullName !== undefined) updateData.fullName = input.fullName;
    if (input.phone !== undefined) updateData.phone = input.phone;
    if (input.avatarUrl !== undefined) updateData.avatarUrl = input.avatarUrl;
    if (input.dateOfBirth !== undefined)
      updateData.dateOfBirth = input.dateOfBirth;

    await this.drizzleService.db
      .update(users)
      .set(updateData)
      .where(eq(users.id, id));

    const updated = await this.drizzleService.db.query.users.findFirst({
      where: eq(users.id, id),
      with: { roles: { columns: { role: true } } },
    });

    if (!updated) {
      throw new Error('User not found after update');
    }

    return new UserEntity(
      updated.id,
      updated.phone,
      updated.identityNumber,
      updated.fullName,
      updated.avatarUrl,
      updated.roles.map((r) => r.role),
      updated.createdAt.toISOString(),
      updated.updatedAt.toISOString(),
      updated.acceptedTerms,
      updated.dateOfBirth ?? null,
    );
  }
}
