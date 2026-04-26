export class LandlordNotFoundError extends Error {
  constructor(message = 'Landlord không tồn tại') {
    super(message);
    this.name = 'LandlordNotFoundError';
  }
}export class PropertiesOperationError extends Error {
    constructor(message: string) {
        super(message);
        this.name = 'PropertiesOperationError';
    }
}

export class PropertiesCannotBeCreatedError extends Error {
    constructor(message = "Không thể tạo mới khu trọ") {
        super(message);
        this.name = 'PropertiesCannotBeCreatedError';
    }
}