import { IsUUID } from 'class-validator';

export class CreateInvoicePaymentDto {
  @IsUUID('4')
  invoiceId!: string;
}

