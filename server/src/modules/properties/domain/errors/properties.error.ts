export class LandlordNotFoundError extends Error {
  constructor(message = 'Landlord khong ton tai') {
    super(message);
    this.name = 'LandlordNotFoundError';
  }
}

export class PropertiesOperationError extends Error {
    constructor(message: string) {
        super(message);
        this.name = 'PropertiesOperationError';
    }
}

export class PropertiesCannotBeCreatedError extends Error {
    constructor(message = "Khong the tao moi khu tro") {
        super(message);
        this.name = 'PropertiesCannotBeCreatedError';
    }
}

export class PropertyNotFoundError extends Error {
    constructor(message = "Khu tro khong ton tai") {
        super(message);
        this.name = 'PropertyNotFoundError';
    }
}
