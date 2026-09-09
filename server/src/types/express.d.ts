import 'express';

declare module 'express' {
  interface Request {
    superAdmin?: string; 
  }
}