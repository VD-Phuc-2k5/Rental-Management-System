import { Request } from 'express';
import { UserDTO } from 'src/shared/dto/user.dto';

export interface AuthenticatedRequest extends Request {
  user: UserDTO;
}
