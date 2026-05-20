export class RoomNotFoundError extends Error {
    constructor(message = "Phong khong ton tai") {
        super(message);
        this.name = "RoomNotFoundError";
    }
}

export class RoomCannotBeCreatedError extends Error {
    constructor(message = "Khong the tao phong") {
        super(message);
        this.name = "RoomCannotBeCreatedError";
    }
}
