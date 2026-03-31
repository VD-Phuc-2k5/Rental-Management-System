export class DuplicateEmailError extends Error {
  constructor(message = 'Email đã được sử dụng, vui lòng sử dụng email khác') {
    super(message);
    this.name = 'DuplicateEmailError';
  }
}

export class InvalidCredentialsError extends Error {
  constructor(message = 'Email hoặc mật khẩu không đúng') {
    super(message);
    this.name = 'InvalidCredentialsError';
  }
}

export class AuthOperationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'AuthOperationError';
  }
}