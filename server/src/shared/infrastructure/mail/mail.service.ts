import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import nodemailer, { Transporter } from 'nodemailer';
import { EnvironmentVariables } from '../../../config/environment.config';

@Injectable()
export class MailService implements OnModuleInit {
  private readonly logger = new Logger(MailService.name);
  private readonly transporter: Transporter;
  private readonly from: string;

  constructor(private readonly configService: ConfigService<EnvironmentVariables, true>) {
    const host = this.configService.getOrThrow<string>('SMTP_HOST');
    const port = Number(this.configService.getOrThrow<string>('SMTP_PORT'));
    const user = this.configService.getOrThrow<string>('SMTP_USER');
    const pass = this.configService.getOrThrow<string>('SMTP_PASS');
    const from = this.configService.getOrThrow<string>('SMTP_FROM');
    const secureFlag = this.configService.get<string>('SMTP_SECURE');
    const secure = secureFlag ? secureFlag.toLowerCase() === 'true' : port === 465;

    this.from = from;
    this.transporter = nodemailer.createTransport({
      host,
      port,
      secure,
      auth: { user, pass },
      pool: true,
      maxConnections: 5,
      maxMessages: 100,
      connectionTimeout: 10000,
      greetingTimeout: 10000,
      socketTimeout: 20000,
    });
  }

  async onModuleInit(): Promise<void> {
    try {
      await this.transporter.verify();
      this.logger.log('SMTP transport verified');
    } catch (error) {
      this.logger.error('SMTP verify failed', error instanceof Error ? error.stack : String(error));
    }
  }

  async sendOtpEmail(to: string, otp: string): Promise<void> {
    await this.transporter.sendMail({
      from: this.from,
      to,
      subject: 'Ma OTP đăt lại mật khẩu',
      text: `Mã OTP của bạn là: ${otp}. Mã có hiệu lực trong 60 giây.`,
      html: `<p>Mã OTP của bạn là: <strong>${otp}</strong>.</p><p>Mã có hiệu lực trong 60 giây.</p>`,
    });
  }
}
