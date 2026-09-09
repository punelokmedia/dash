import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from "@nestjs/common";
import { Observable } from "rxjs";
import { map } from "rxjs/operators";
import { Request } from "express";

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  message?: string;
}

@Injectable()
export class ResponseInterceptor<T> implements NestInterceptor<
  T,
  ApiResponse<T>
> {
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<ApiResponse<T>> {
    const request = context.switchToHttp().getRequest<Request>();

    return next.handle().pipe(
      map((data) => {
        if (data && typeof data === "object" && "success" in data) {
          return data as ApiResponse<T>;
        }

        if (data && typeof data === "object" && "data" in data) {
          return {
            success: true,
            message: (data as any).message || "Success",
            data: (data as any).data,
          };
        }

        return {
          success: true,
          message: "Success",
          data,
        };
      }),
    );
  }
}
