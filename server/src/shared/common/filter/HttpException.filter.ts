import {
    ExceptionFilter,
    Catch,
    ArgumentsHost,
    HttpException,
  } from '@nestjs/common';
import { Request, Response } from 'express';

  @Catch(HttpException)
  export class HttpExceptionFilter implements ExceptionFilter {
    catch(exception: HttpException, host: ArgumentsHost) {
      const ctx = host.switchToHttp();
      const response = ctx.getResponse<Response>();
      const request = ctx.getRequest<Request>();
      const status = exception.getStatus();
      const exceptionResponse = exception.getResponse();

      const details =
        typeof exceptionResponse === 'string'
          ? { message: exceptionResponse }
          : exceptionResponse;

      const message =
        typeof details === 'object' && details !== null && 'message' in details
          ? Array.isArray(details.message)
            ? details.message[0]
            : details.message
          : exception.message;

      response.status(status).json({
        statusCode: status,
        message,
        error: exception.name,
        details,
        path: request.url,
      });
    }
  }
  