import { Request } from 'express';

export type AuthenticatedUser = {
  id: string;
  email: string;
  roles: string[];
  
};

export interface AuthenticatedRequest extends Request {
  user: AuthenticatedUser;
}
