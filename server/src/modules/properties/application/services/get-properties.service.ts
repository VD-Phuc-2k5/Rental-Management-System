import { Inject } from '@nestjs/common';
import { PropertiesRepository } from '../../domain/repositories/properties.repository';
import { PropertiesEntity } from '../../domain/entities/properties.entity';

export class GetPropertiesService {
  constructor(
    @Inject(PropertiesRepository)
    private readonly propertiesRepository: PropertiesRepository,
  ) {}

  async execute(landlorerId: string): Promise<PropertiesEntity[]> {
    return this.propertiesRepository.findAllByLandlordId(landlorerId);
  }
}
