import { Inject } from "@nestjs/common";
import { CreateUserInput, UserRepository } from "../../domain/repositories/user.repository";

export class FindUserService {
    constructor(
        @Inject(UserRepository)
        private readonly userRepository: UserRepository
    ) {}

    public async execute(id: string): Promise<void> {
        await this.userRepository.findById(id);
    }
}