import { IsUUID } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateDepositPaymentDto {
  @ApiProperty()
  @IsUUID()
  contractId: string;
}
