import { Inject, Injectable } from "@nestjs/common";
import { AuthRepository } from "../../domain/repositories/auth.repository";


@Injectable()
export class LoginService {
  constructor(
    @Inject(AuthRepository)
    private readonly authRepository: AuthRepository,
  ) {}

    async execute(email: string, password: string) {
        const token = await this.authRepository.login(email, password);
        
        return { token };
    }
}