import { createParamDecorator, ExecutionContext } from '@nestjs/common';
import { UserDTO } from 'src/shared/dto/user.dto';

export const CurrentUser = createParamDecorator(
  (_data: unknown, ctx: ExecutionContext): UserDTO => {
    const request = ctx.switchToHttp().getRequest<{ user: UserDTO }>();
    return request.user;
  },
);
