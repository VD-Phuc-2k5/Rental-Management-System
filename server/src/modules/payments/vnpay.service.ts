import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createHmac } from 'crypto';
import { ContractRepository } from '../rental-requests/domain/repositories/contract.repository';
import { SignContractService } from '../rental-requests/application/services/sign-contract.service';

export interface VnpayPaymentResult {
  payUrl: string;
  deeplink: string;
  qrCodeUrl: string;
}

export interface VnpayVerifyResult {
  isVerified: boolean;
  isSuccess: boolean;
  responseCode: string;
  orderInfo: string;
}

@Injectable()
export class VnpayService {
  private readonly logger = new Logger('VnpayService');
  private readonly tmnCode: string;
  private readonly hashSecret: string;
  private readonly baseUrl: string;
  private readonly returnUrl: string;
  private readonly ipnUrl: string;

  constructor(
    config: ConfigService,
    private readonly contractRepo: ContractRepository,
    private readonly signContractService: SignContractService,
  ) {
    this.tmnCode = config.get<string>('VNPAY_TMN_CODE', '').trim();
    this.hashSecret = config.get<string>('VNPAY_HASH_SECRET', '').trim();
    this.baseUrl = config
      .get<string>(
        'VNPAY_BASE_URL',
        'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
      )
      .trim();
    this.returnUrl = config.get<string>('VNPAY_RETURN_URL', '').trim();
    this.ipnUrl = config.get<string>('VNPAY_IPN_URL', '').trim();

    if (!this.tmnCode || !this.hashSecret) {
      this.logger.error(
        'VNPay credentials are missing in environment variables.',
      );
    }

    if (this.hashSecret) {
      const masked =
        this.hashSecret.slice(0, 4) + '****' + this.hashSecret.slice(-4);
      const testHash = createHmac('sha512', this.hashSecret)
        .update('test', 'utf-8')
        .digest('hex');
      this.logger.debug(
        `VNPay config: tmnCode=${this.tmnCode} hashSecret=${masked} len=${this.hashSecret.length}`,
      );
      this.logger.debug(`VNPay HMAC test: HMAC-SHA512("test")=${testHash}`);
      this.logger.debug(
        `VNPay returnUrl=${this.returnUrl} baseUrl=${this.baseUrl}`,
      );
    }
  }

  async createDepositPayment(
    contractId: string,
    tenantId: string,
    clientIp: string,
  ): Promise<VnpayPaymentResult> {
    const contract = await this.contractRepo.findById(contractId);
    if (!contract) throw new NotFoundException('Contract not found');
    if (contract.tenantId !== tenantId) throw new ForbiddenException();
    if (contract.status !== 'sent')
      throw new BadRequestException('Contract must be in sent status');

    const orderId = `VNP_${contractId.replace(/-/g, '').slice(0, 16)}_${Date.now()}`;
    const rawDeposit = String(contract.deposit ?? '0').replace(
      /[^0-9.-]+/g,
      '',
    );
    const amount = Math.round(Number(rawDeposit) || 0);
    const orderInfo = Buffer.from(
      JSON.stringify({ contractId, tenantId }),
    ).toString('base64');

    const expireDate = new Date();
    expireDate.setMinutes(expireDate.getMinutes() + 15);

    const params: Record<string, string> = {
      vnp_Amount: String(amount * 100),
      vnp_Command: 'pay',
      vnp_CreateDate: this.formatDate(),
      vnp_CurrCode: 'VND',
      vnp_ExpireDate: this.formatDate(expireDate),
      vnp_IpAddr: this.normalizeIp(clientIp),
      vnp_Locale: 'vn',
      vnp_OrderInfo: orderInfo,
      vnp_OrderType: 'other',
      vnp_ReturnUrl: this.returnUrl,
      vnp_TmnCode: this.tmnCode,
      vnp_TxnRef: orderId,
      vnp_Version: '2.1.0',
    };

    const payUrl = this.buildPaymentUrl(params);

    return {
      payUrl,
      deeplink: payUrl,
      qrCodeUrl: payUrl,
    };
  }

  async handleIpn(ipnData: Record<string, unknown>): Promise<void> {
    const normalized = this.normalizeQuery(ipnData);

    this.logger.debug(
      `VNPay IPN raw keys=${JSON.stringify(Object.keys(ipnData).sort())}`,
    );
    this.logger.debug(
      `VNPay IPN normalized keys=${JSON.stringify(Object.keys(normalized).sort())}`,
    );
    this.logger.debug(
      `VNPay IPN normalized data=${JSON.stringify(normalized)}`,
    );

    const rawHash = ipnData.vnp_SecureHash;
    const signature = typeof rawHash === 'string' ? rawHash : '';

    // VNPay merchant portal test IPN sends hash_test as placeholder
    if (signature === 'hash_test') {
      this.logger.debug('VNPay IPN test call accepted (hash_test)');
      return;
    }

    const hashQuery = this.buildHashQuery(normalized);
    const hash512 = createHmac('sha512', this.hashSecret)
      .update(hashQuery, 'utf-8')
      .digest('hex');

    this.logger.debug(
      `VNPay IPN txnRef=${normalized.vnp_TxnRef ?? ''} hashData=${hashQuery}`,
    );
    this.logger.debug(`VNPay IPN hash512=${hash512} received=${signature}`);
    this.logger.debug(`VNPay IPN orderInfo=${normalized.vnp_OrderInfo ?? ''}`);

    if (hash512 !== signature) {
      this.logger.warn(
        `VNPay IPN invalid signature for txnRef=${normalized.vnp_TxnRef ?? ''}`,
      );
      throw new BadRequestException('Invalid checksum');
    }

    if (!this.isPaymentSuccess(normalized)) {
      this.logger.log(
        `VNPay payment failed responseCode=${normalized.vnp_ResponseCode ?? ''} txnRef=${normalized.vnp_TxnRef ?? ''}`,
      );
      return;
    }

    await this.applySuccessfulPayment(normalized, 'IPN');
  }

  verifyReturnQuery(query: Record<string, string>): VnpayVerifyResult {
    const receivedHash = query.vnp_SecureHash;

    const keys = Object.keys(query)
      .filter((k) => k !== 'vnp_SecureHash' && k !== 'vnp_SecureHashType')
      .sort();

    const sorted: Record<string, string> = {};
    for (const key of keys) {
      const v = query[key];
      if (v) sorted[key] = v;
    }

    const hashQuery = this.buildHashQuery(sorted);
    const hash512 = createHmac('sha512', this.hashSecret)
      .update(hashQuery, 'utf-8')
      .digest('hex');
    const isVerified = hash512 === (receivedHash ?? '');

    return {
      isVerified,
      isSuccess: sorted.vnp_ResponseCode === '00',
      responseCode: sorted.vnp_ResponseCode ?? '',
      orderInfo: sorted.vnp_OrderInfo ?? '',
    };
  }

  async finalizeReturn(query: Record<string, string>): Promise<void> {
    const { isVerified, isSuccess } = this.verifyReturnQuery(query);
    if (!isVerified) throw new BadRequestException('Invalid checksum');
    if (!isSuccess) return;

    const normalized = this.normalizeQuery(query);
    await this.applySuccessfulPayment(normalized, 'RETURN');
  }

  private buildPaymentUrl(params: Record<string, string>): string {
    const sortedKeys = Object.keys(params).sort();

    const hashQuery = this.buildHashQuery(params);
    const secureHash = createHmac('sha512', this.hashSecret)
      .update(hashQuery, 'utf-8')
      .digest('hex');

    const urlQuery = sortedKeys
      .map(
        (key) =>
          `${key}=${encodeURIComponent(params[key]).replace(/%20/g, '+')}`,
      )
      .join('&');

    this.logger.debug(
      `VNPay sign txnRef=${params.vnp_TxnRef} tmnCode=${params.vnp_TmnCode} hashData=${hashQuery} hash=${secureHash}`,
    );

    return `${this.baseUrl}?${urlQuery}&vnp_SecureHash=${secureHash}`;
  }

  private normalizeQuery(
    data: Record<string, unknown>,
  ): Record<string, string> {
    const normalized: Record<string, string> = {};
    for (const key of Object.keys(data).sort()) {
      if (key === 'vnp_SecureHash' || key === 'vnp_SecureHashType') continue;
      const value = data[key];
      if (typeof value === 'string' || typeof value === 'number') {
        const str = String(value);
        if (str.length > 0) normalized[key] = str;
      }
    }
    return normalized;
  }

  private signHash(params: Record<string, string>): string {
    const hashQuery = this.buildHashQuery(params);
    return createHmac('sha512', this.hashSecret)
      .update(hashQuery, 'utf-8')
      .digest('hex');
  }

  private isPaymentSuccess(params: Record<string, string>): boolean {
    return (
      params.vnp_ResponseCode === '00' &&
      params.vnp_TransactionStatus === '00'
    );
  }

  private async applySuccessfulPayment(
    params: Record<string, string>,
    source: 'IPN' | 'RETURN',
  ): Promise<void> {
    let contractId: string;
    let tenantId: string;
    try {
      const decoded = JSON.parse(
        Buffer.from(params.vnp_OrderInfo ?? '', 'base64').toString(),
      ) as { contractId: string; tenantId: string };
      contractId = decoded.contractId;
      tenantId = decoded.tenantId;
    } catch {
      this.logger.error(
        `VNPay ${source} failed to decode order info: ${params.vnp_OrderInfo ?? ''}`,
      );
      return;
    }

    const contract = await this.contractRepo.findById(contractId);
    if (!contract) {
      this.logger.error(`VNPay ${source} contract not found: ${contractId}`);
      return;
    }

    const expectedAmount =
      Math.round(
        Number(String(contract.deposit ?? '').replace(/[^0-9.-]+/g, '')) || 0,
      ) * 100;
    if (String(expectedAmount) !== (params.vnp_Amount ?? '')) {
      this.logger.error(
        `VNPay ${source} amount mismatch contractId=${contractId} expected=${expectedAmount} received=${params.vnp_Amount ?? ''}`,
      );
      return;
    }

    try {
      await this.signContractService.execute(contractId, tenantId);
      this.logger.log(
        `Contract ${contractId} signed via VNPay ${source} txnRef=${params.vnp_TxnRef ?? ''}`,
      );
    } catch (error: unknown) {
      const message = error instanceof Error ? error.message : String(error);
      this.logger.warn(
        `VNPay ${source} sign skipped contractId=${contractId}: ${message}`,
      );
    }
  }

  private buildHashQuery(params: Record<string, string>): string {
    return Object.keys(params)
      .sort()
      .filter((key) => params[key] !== undefined && params[key] !== '')
      .map(
        (key) =>
          `${key}=${encodeURIComponent(params[key]).replace(/%20/g, '+')}`,
      )
      .join('&');
  }

  private formatDate(date?: Date): string {
    const now = date ?? new Date();
    const utcMillis = now.getTime() + now.getTimezoneOffset() * 60_000;
    const vnDate = new Date(utcMillis + 7 * 60 * 60_000);
    const pad = (value: number): string => String(value).padStart(2, '0');
    return [
      vnDate.getFullYear(),
      pad(vnDate.getMonth() + 1),
      pad(vnDate.getDate()),
      pad(vnDate.getHours()),
      pad(vnDate.getMinutes()),
      pad(vnDate.getSeconds()),
    ].join('');
  }

  private normalizeIp(clientIp: string): string {
    const ip = (clientIp || '').trim();
    if (!ip || ip.includes(':')) {
      return '127.0.0.1';
    }
    return ip;
  }
}
