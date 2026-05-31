import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PayOS } from '@payos/node';
import { ContractRepository } from '../rental-requests/domain/repositories/contract.repository';
import { SignContractService } from '../rental-requests/application/services/sign-contract.service';
import { DrizzleService } from 'src/shared/infrastructure/database/drizzle.service';
import { contracts, invoices } from 'src/shared/infrastructure/database/schema';
import { eq } from 'drizzle-orm';

export interface PayosPaymentResult {
  payUrl: string;
  deeplink: string;
  qrCodeUrl: string | null;
}

@Injectable()
export class PayosService {
  private readonly logger = new Logger('PayosService');
  private readonly payos: PayOS | null = null;
  private readonly returnUrl: string;
  private readonly cancelUrl: string;

  constructor(
    config: ConfigService,
    private readonly contractRepo: ContractRepository,
    private readonly signContractService: SignContractService,
    private readonly drizzle: DrizzleService,
  ) {
    const clientId = config.get<string>('PAYOS_CLIENT_ID', '').trim();
    const apiKey = config.get<string>('PAYOS_API_KEY', '').trim();
    const checksumKey = config.get<string>('PAYOS_CHECKSUM_KEY', '').trim();

    this.returnUrl = config.get<string>('PAYOS_RETURN_URL', '').trim() || 'http://localhost:3000/payments/payos/return';
    this.cancelUrl = config.get<string>('PAYOS_CANCEL_URL', '').trim() || 'http://localhost:3000/payments/payos/cancel';

    if (clientId && apiKey && checksumKey) {
      try {
        this.payos = new PayOS({
          clientId,
          apiKey,
          checksumKey,
        });
        this.logger.log('PayOS Service initialized successfully.');
      } catch (err: any) {
        this.logger.error('Failed to initialize PayOS Client: ' + err.message);
      }
    } else {
      const missing: string[] = [];
      if (!clientId) missing.push('PAYOS_CLIENT_ID');
      if (!apiKey) missing.push('PAYOS_API_KEY');
      if (!checksumKey) missing.push('PAYOS_CHECKSUM_KEY');
      this.logger.warn(`PayOS keys missing in env: ${missing.join(', ')}. Running in Sandbox/Mock mode.`);
    }
  }

  async createDepositPayment(
    contractId: string,
    tenantId: string,
  ): Promise<PayosPaymentResult> {
    const contract = await this.contractRepo.findById(contractId);
    if (!contract) throw new NotFoundException('Contract not found');
    if (contract.tenantId !== tenantId) throw new ForbiddenException();
    if (contract.status !== 'sent')
      throw new BadRequestException('Contract must be in sent status');

    const rawDeposit = String(contract.deposit ?? '0').replace(
      /[^0-9.-]+/g,
      '',
    );
    const amount = Math.round(Number(rawDeposit) || 0);

    // PayOS orderCode must be a unique numeric value (Safe integer)
    const orderCode = Date.now(); 
    
    // Store the orderCode in the contract so we can look it up upon Webhook notification
    await this.contractRepo.update(contractId, {
      vnpayNumber: String(orderCode),
    });

    const description = `Coc phong ${contractId.slice(0, 8)}`; // Alphanumeric diacritic-free, max 25 chars

    if (this.payos) {
      try {
        const paymentLink = await this.payos.paymentRequests.create({
          orderCode,
          amount,
          description,
          returnUrl: this.returnUrl,
          cancelUrl: this.cancelUrl,
        });
        console.log({
          payUrl: paymentLink.checkoutUrl,
          deeplink: paymentLink.checkoutUrl,
          qrCodeUrl: paymentLink.qrCode,
        });

        return {
          payUrl: paymentLink.checkoutUrl,
          deeplink: paymentLink.checkoutUrl,
          qrCodeUrl: paymentLink.qrCode,
        };
      } catch (err: any) {
        this.logger.error(`PayOS createPaymentLink error: ${err.message}`);
        throw new BadRequestException(`PayOS error: ${err.message}`);
      }
    } else {
      // Sandbox Mock mode if keys are not set yet
      const mockCheckoutUrl = `https://checkout.payos.vn/web/${contractId}`;
      this.logger.warn(`PayOS Mock Link created: ${mockCheckoutUrl}`);
      return {
        payUrl: mockCheckoutUrl,
        deeplink: mockCheckoutUrl,
        qrCodeUrl: null,
      };
    }
  }

  async createInvoicePayment(
    invoiceId: string,
    tenantId: string,
  ): Promise<PayosPaymentResult> {
    const [invoice] = await this.drizzle.db
      .select()
      .from(invoices)
      .where(eq(invoices.id, invoiceId));

    if (!invoice) throw new NotFoundException('Invoice not found');
    if (invoice.tenantId !== tenantId) throw new ForbiddenException();
    if (invoice.status !== 'finalized') {
      throw new BadRequestException('Invoice must be in finalized status');
    }

    const amount = Math.round(Number(invoice.total) || 0);
    if (!amount || amount <= 0) {
      throw new BadRequestException('Invoice amount is invalid');
    }

    // PayOS orderCode must be a unique numeric value (Safe integer)
    const orderCode = Date.now();
    const description = `INV ${invoiceId}`.slice(0, 25);

    if (this.payos) {
      try {
        const paymentLink = await this.payos.paymentRequests.create({
          orderCode,
          amount,
          description,
          returnUrl: this.returnUrl,
          cancelUrl: this.cancelUrl,
        });
        console.log( {
          payUrl: paymentLink.checkoutUrl,
          deeplink: paymentLink.checkoutUrl,
          qrCodeUrl: paymentLink.qrCode,
        });

        return {
          payUrl: paymentLink.checkoutUrl,
          deeplink: paymentLink.checkoutUrl,
          qrCodeUrl: paymentLink.qrCode,
        };
      } catch (err: any) {
        this.logger.error(`PayOS createPaymentLink error: ${err.message}`);
        throw new BadRequestException(`PayOS error: ${err.message}`);
      }
    }

    // Sandbox Mock mode if keys are not set yet
    const mockCheckoutUrl = `https://checkout.payos.vn/web/${invoiceId}`;
    this.logger.warn(`PayOS Mock Invoice Link created: ${mockCheckoutUrl}`);
    return {
      payUrl: mockCheckoutUrl,
      deeplink: mockCheckoutUrl,
      qrCodeUrl: null,
    };
  }

  async confirmInvoicePayment(invoiceId: string): Promise<void> {
    const [invoice] = await this.drizzle.db
      .select()
      .from(invoices)
      .where(eq(invoices.id, invoiceId));

    if (!invoice) throw new NotFoundException('Invoice not found');

    await this.drizzle.db
      .update(invoices)
      .set({ status: 'paid', paidAt: new Date(), updatedAt: new Date() })
      .where(eq(invoices.id, invoiceId));

    this.logger.log(`Invoice ${invoiceId} manually confirmed as paid`);
  }

  async handleWebhook(body: any): Promise<void> {
    this.logger.debug(`PayOS Webhook received: ${JSON.stringify(body)}`);
    
    let data = body.data;
    if (this.payos) {
      try {
        // PayOS verifies webhook signature using webhooks.verify
        data = await this.payos.webhooks.verify(body);
      } catch (err: any) {
        this.logger.warn(`PayOS signature verification failed: ${err.message}`);
        throw new BadRequestException('Invalid signature');
      }
    }

    if (!data) return;

    const orderCode = String(data.orderCode);
    const [contractRow] = await this.drizzle.db
      .select()
      .from(contracts)
      .where(eq(contracts.vnpayNumber, orderCode));

    // body.code là trường success ở top-level của PayOS webhook v2
    // (body.data thường không chứa 'code')
    const isSuccess = body.code === '00' || data.code === '00';
    if (!isSuccess) {
      this.logger.warn(`PayOS webhook skipped — not a success event (body.code=${body.code}, data.code=${data.code})`);
      return;
    }

    if (contractRow) {
      try {
        await this.signContractService.execute(contractRow.id, contractRow.tenantId);
        this.logger.log(`Contract ${contractRow.id} signed via PayOS webhook`);
      } catch (err: any) {
        this.logger.warn(`Failed to execute sign contract: ${err.message}`);
      }
      return;
    }

    // If not a contract payment, try matching an invoice via description: "INV <uuid>"
    const rawDesc = String(data.description ?? '');
    const match = rawDesc.match(
      /[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}/,
    );
    const invoiceId = match?.[0];
    if (!invoiceId) {
      this.logger.warn(
        `No contract or invoice matched PayOS orderCode: ${orderCode}`,
      );
      return;
    }

    try {
      await this.drizzle.db
        .update(invoices)
        .set({ status: 'paid', paidAt: new Date(), updatedAt: new Date() })
        .where(eq(invoices.id, invoiceId));
      this.logger.log(`Invoice ${invoiceId} paid via PayOS webhook`);
    } catch (err: any) {
      this.logger.warn(`Failed to mark invoice paid: ${err.message}`);
    }
  }
}
