import { validate } from 'class-validator';
import { plainToInstance } from 'class-transformer';
import { RegisterDto } from '../../../src/modules/auth/application/dto/register.dto';
import { VerifyOtpDto } from '../../../src/modules/auth/application/dto/verify-otp.dto';

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function validTenant(): Record<string, any> {
  return {
    email: 'tenant@gmail.com',
    fullName: 'Nguyen Van A',
    phone: '0912345678',
    password: 'Test@1234',
    confirm_password: 'Test@1234',
    accepted_terms: true,
  };
}

function validLandlord(): Record<string, any> {
  return {
    ...validTenant(),
    identity_number: '123456789012',
  };
}

async function expectValid(dtoClass: any, data: Record<string, any>) {
  const dto = plainToInstance(dtoClass, data);
  const errors = await validate(dto as any);
  expect(errors.length).toBe(0);
}

async function expectInvalid(dtoClass: any, data: Record<string, any>, property: string) {
  const dto = plainToInstance(dtoClass, data);
  const errors = await validate(dto as any);
  const props = errors.map((e) => e.property);
  expect(props).toContain(property);
}

// ---------------------------------------------------------------------------
// BVA: Register DTO
// ---------------------------------------------------------------------------

describe('RegisterDto — Password length', () => {
  it('AUTH-012: Password 7 chars (biên(min) - 1) → 400', async () => {
    await expectInvalid(RegisterDto, { ...validTenant(), password: 'A1@bcde', confirm_password: 'A1@bcde' }, 'password');
  });

  it('AUTH-013: Password 8 chars (biên(min)) → 201', async () => {
    await expectValid(RegisterDto, { ...validTenant(), password: 'A1@bcdef', confirm_password: 'A1@bcdef' });
  });

  it('AUTH-053: Password 9 chars (biên(min) + 1) → 201', async () => {
    await expectValid(RegisterDto, { ...validTenant(), password: 'A1@bcdefg', confirm_password: 'A1@bcdefg' });
  });

  it('AUTH-054: Password 71 chars (biên(max) - 1) → 201', async () => {
    await expectValid(RegisterDto, { ...validTenant(), password: 'A1@' + 'a'.repeat(68), confirm_password: 'A1@' + 'a'.repeat(68) });
  });

  it('AUTH-014: Password 72 chars (biên(max)) → 201', async () => {
    await expectValid(RegisterDto, { ...validTenant(), password: 'A1@' + 'a'.repeat(69), confirm_password: 'A1@' + 'a'.repeat(69) });
  });

  it('AUTH-015: Password 73 chars (biên(max) + 1) → 400', async () => {
    await expectInvalid(RegisterDto, { ...validTenant(), password: 'A1@' + 'a'.repeat(70), confirm_password: 'A1@' + 'a'.repeat(70) }, 'password');
  });
});

describe('RegisterDto — Phone length', () => {
  it('AUTH-016: Phone 9 chars (biên(min) - 1) → 400', async () => {
    await expectInvalid(RegisterDto, { ...validTenant(), phone: '012345678' }, 'phone');
  });

  it('AUTH-017: Phone 10 chars (biên) → 201', async () => {
    await expectValid(RegisterDto, { ...validTenant(), phone: '0123456789' });
  });

  it('AUTH-055: Phone 11 chars (biên(max) + 1) → 400', async () => {
    await expectInvalid(RegisterDto, { ...validTenant(), phone: '01234567890' }, 'phone');
  });
});

describe('RegisterDto — fullName length', () => {
  it('AUTH-020: fullName 1 char (biên(min) - 1) → 400', async () => {
    await expectInvalid(RegisterDto, { ...validTenant(), fullName: 'A' }, 'fullName');
  });

  it('AUTH-056: fullName 2 chars (biên(min)) → 201', async () => {
    await expectValid(RegisterDto, { ...validTenant(), fullName: 'An' });
  });

  it('AUTH-057: fullName 99 chars (biên(max) - 1) → 201', async () => {
    await expectValid(RegisterDto, { ...validTenant(), fullName: 'A'.repeat(99) });
  });

  it('AUTH-021: fullName 100 chars (biên(max)) → 201', async () => {
    await expectValid(RegisterDto, { ...validTenant(), fullName: 'A'.repeat(100) });
  });

  it('AUTH-022: fullName 101 chars (biên(max) + 1) → 400', async () => {
    await expectInvalid(RegisterDto, { ...validTenant(), fullName: 'A'.repeat(101) }, 'fullName');
  });
});

describe('RegisterDto — identity_number length', () => {
  it('AUTH-023: identity_number 11 chars (biên(min) - 1) → 400', async () => {
    await expectInvalid(RegisterDto, { ...validLandlord(), identity_number: '1'.repeat(11) }, 'identity_number');
  });

  it('AUTH-024: identity_number 12 chars (biên) → 201', async () => {
    await expectValid(RegisterDto, { ...validLandlord(), identity_number: '1'.repeat(12) });
  });

  it('AUTH-025: identity_number 13 chars (biên(max) + 1) → 400', async () => {
    await expectInvalid(RegisterDto, { ...validLandlord(), identity_number: '1'.repeat(13) }, 'identity_number');
  });
});

// ---------------------------------------------------------------------------
// BVA: VerifyOtpDto
// ---------------------------------------------------------------------------

describe('VerifyOtpDto — OTP length', () => {
  it('AUTH-036: OTP 5 chars (biên(min) - 1) → 400', async () => {
    await expectInvalid(VerifyOtpDto, { email: 'test@gmail.com', otp: '12345' }, 'otp');
  });

  it('AUTH-058: OTP 6 chars (biên) → 201', async () => {
    await expectValid(VerifyOtpDto, { email: 'test@gmail.com', otp: '123456' });
  });

  it('AUTH-059: OTP 7 chars (biên(max) + 1) → 400', async () => {
    await expectInvalid(VerifyOtpDto, { email: 'test@gmail.com', otp: '1234567' }, 'otp');
  });
});
