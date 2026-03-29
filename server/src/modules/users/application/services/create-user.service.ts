import { Inject } from "@nestjs/common";
import { CreateUserInput, UserRepository } from "../../domain/repositories/user.repository";

export class CreateUserService {
    constructor(
        @Inject(UserRepository)
        private readonly userRepository: UserRepository
    ) {}

    public async execute(input: CreateUserInput): Promise<void> {
        await this.userRepository.create(input);
    }
}