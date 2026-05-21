import { UserEntity } from '../../domain/entities/user.entity';
import { UserDTO } from '../../../../shared/dto/user.dto';

export class ProfileResponseDto {
  id: string;
  fullName: string;
  email: string;
  phone: string;
  role: string;
  dateOfBirth: string | null;
  avatarUrl: string | null;

  static from(entity: UserEntity, currentUser: UserDTO): ProfileResponseDto {
    const dto = new ProfileResponseDto();
    dto.id = entity.id;
    dto.fullName = entity.fullName;
    dto.email = currentUser.email;
    dto.phone = entity.phone ?? '';
    dto.role = entity.role[0] ?? 'tenant';
    dto.dateOfBirth = entity.dateOfBirth;
    dto.avatarUrl = entity.avatarUrl;
    return dto;
  }
}
