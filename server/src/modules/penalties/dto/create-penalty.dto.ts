import { IsString, IsNumber, IsUUID, IsNotEmpty } from 'class-validator';

export class CreatePenaltyDto {
  @IsUUID()
  @IsNotEmpty()
  contractId: string;

  @IsUUID()
  @IsNotEmpty()
  tenantId: string;

  @IsUUID()
  @IsNotEmpty()
  roomId: string;

  @IsNumber()
  @IsNotEmpty()
  amount: number;

  @IsString()
  @IsNotEmpty()
  reason: string;
}
