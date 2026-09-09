/**
 * Type declaration for @aws-sdk/client-s3 when the package is not installed.
 * Run: npm install @aws-sdk/client-s3
 */
declare module '@aws-sdk/client-s3' {
  export class S3Client {
    constructor(config?: unknown);
    send(command: unknown): Promise<unknown>;
  }
  export class PutObjectCommand {
    constructor(params: {
      Bucket: string;
      Key: string;
      Body: Buffer | Uint8Array;
      ContentType?: string;
      ACL?: string;
    });
  }
}
