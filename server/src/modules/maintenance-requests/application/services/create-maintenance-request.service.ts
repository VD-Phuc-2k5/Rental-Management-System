import { BadRequestException, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';

import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { contracts } from 'src/shared/infrastructure/database/schema';

import { CreateMaintenanceRequestDto } from '../dto/create-maintenance-request.dto';
import { MaintenanceRequestEntity } from '../../domain/entities/maintenance-request.entity';
import { MaintenanceRequestRepository } from '../../domain/repositories/maintenance-request.repository';

@Injectable()
export class CreateMaintenanceRequestService {
  constructor(
    private readonly maintenanceRequestRepo: MaintenanceRequestRepository,
    private readonly drizzle: DrizzleService,
  ) {}

  async execute(
    tenantId: string,
    dto: CreateMaintenanceRequestDto,
  ): Promise<MaintenanceRequestEntity> {
    const conditions = [
      eq(contracts.tenantId, tenantId),
      eq(contracts.status, 'signed'),
    ];

    if (dto.roomId) {
      conditions.push(eq(contracts.roomId, dto.roomId));
    }

    const [activeContract] = await this.drizzle.db
      .select({
        roomId: contracts.roomId,
        landlordId: contracts.landlordId,
      })
      .from(contracts)
      .where(and(...conditions))
      .limit(1);

    if (!activeContract) {
      throw new BadRequestException(
        'Bạn chưa có hợp đồng thuê phòng đang hoạt động nên không thể gửi yêu cầu sửa chữa',
      );
    }

    return this.maintenanceRequestRepo.create({
      tenantId,
      landlordId: activeContract.landlordId,
      roomId: activeContract.roomId,
      title: dto.title.trim(),
      description: dto.description?.trim() ?? '',
      location: dto.location?.trim() || 'Chưa xác định',
      priority: dto.priority ?? 'low',
      imageUrls: dto.imageUrls ?? [],
    });
  }
}