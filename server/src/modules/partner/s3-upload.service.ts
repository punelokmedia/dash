import { Injectable, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DocumentType } from './types/document.types';
import type { MulterFile } from '../../types/multer';

const PROFILE_IMAGE_MIMES = ['image/jpeg', 'image/png', 'image/webp', 'image/gif'];
const PROFILE_MAX_BYTES = 5 * 1024 * 1024; // 5 MB
const DOCUMENT_MAX_BYTES = 2 * 1024 * 1024; // 2 MB – Aadhaar image/PDF, PAN card
const DOCUMENT_IMAGE_MIMES = ['image/jpeg', 'image/png', 'image/webp'];
const DOCUMENT_PDF_MIME = 'application/pdf';
const DOCUMENT_ALLOWED_MIMES = [...DOCUMENT_IMAGE_MIMES, DOCUMENT_PDF_MIME];

type AwsSdkS3 = typeof import('@aws-sdk/client-s3');
type S3ClientInstance = { send: (command: unknown) => Promise<unknown> };

function tryLoadAwsSdkS3(): AwsSdkS3 | null {
  try {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    return require('@aws-sdk/client-s3') as AwsSdkS3;
  } catch {
    return null;
  }
}

/**
 * Uploads partner profile images to AWS S3. Requires AWS_* and S3_BUCKET_NAME in .env.
 */
@Injectable()
export class S3UploadService {
  private readonly sdk: AwsSdkS3 | null;
  private readonly s3: S3ClientInstance | null;
  private readonly bucket: string;
  private readonly region: string;

  constructor(private readonly config: ConfigService) {
    this.sdk = tryLoadAwsSdkS3();
    const region = this.config.get<string>('aws.region');
    const accessKeyId = this.config.get<string>('aws.accessKeyId');
    const secretAccessKey = this.config.get<string>('aws.secretAccessKey');
    this.bucket = this.config.get<string>('aws.s3Bucket') || '';
    this.region = region || 'ap-south-1';

    this.s3 =
      this.sdk != null
        ? (new this.sdk.S3Client({
            region: this.region,
            ...(accessKeyId && secretAccessKey
              ? { credentials: { accessKeyId, secretAccessKey } }
              : {}),
          }) as unknown as S3ClientInstance)
        : null;
  }

  isConfigured(): boolean {
    return Boolean(
      this.sdk &&
        this.s3 &&
        this.bucket &&
        this.config.get<string>('aws.accessKeyId'),
    );
  }

  private ensureSdkReady(): { sdk: AwsSdkS3; s3: S3ClientInstance } {
    if (!this.sdk || !this.s3) {
      throw new BadRequestException(
        'S3 upload is not available. Install "@aws-sdk/client-s3" and configure AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, and S3_BUCKET_NAME.',
      );
    }
    return { sdk: this.sdk, s3: this.s3 };
  }

  async uploadProfilePhoto(
    partnerId: string,
    file: MulterFile,
  ): Promise<string> {
    if (!this.isConfigured()) {
      throw new BadRequestException(
        'File upload is not configured. Install "@aws-sdk/client-s3" and set AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, and S3_BUCKET_NAME in .env',
      );
    }
    const { sdk, s3 } = this.ensureSdkReady();
    if (!file?.buffer) throw new BadRequestException('No file provided');
    if (file.size > PROFILE_MAX_BYTES) {
      throw new BadRequestException(
        `File too large. Maximum size is ${PROFILE_MAX_BYTES / 1024 / 1024} MB`,
      );
    }
    const mime = file.mimetype || '';
    if (!PROFILE_IMAGE_MIMES.includes(mime)) {
      throw new BadRequestException(
        `Invalid file type. Allowed: ${PROFILE_IMAGE_MIMES.join(', ')}`,
      );
    }
    const ext = mime.split('/')[1] || 'jpg';
    const safeName = (file.originalname || 'photo')
      .replace(/[^a-zA-Z0-9.-]/g, '_')
      .slice(0, 50);
    const key = `partners/${partnerId}/profile/${Date.now()}-${safeName}.${ext}`;

    await s3.send(
      new sdk.PutObjectCommand({
        Bucket: this.bucket,
        Key: key,
        Body: file.buffer,
        ContentType: mime,
        ACL: 'public-read',
      }),
    );
    return `https://${this.bucket}.s3.${this.region}.amazonaws.com/${key}`;
  }

  /**
   * Upload document: Aadhaar image, Aadhaar PDF, or PAN card. Max 2 MB.
   * Allowed: image (jpeg, png, webp) or PDF.
   */
  async uploadDocument(
    partnerId: string,
    file: MulterFile,
    type: DocumentType,
  ): Promise<string> {
    if (!this.isConfigured()) {
      throw new BadRequestException(
        'File upload is not configured. Install "@aws-sdk/client-s3" and set AWS_* and S3_BUCKET_NAME in .env',
      );
    }
    const { sdk, s3 } = this.ensureSdkReady();
    if (!file?.buffer) throw new BadRequestException('No file provided');
    if (file.size > DOCUMENT_MAX_BYTES) {
      throw new BadRequestException(
        `File too large. Maximum size is 2 MB for documents.`,
      );
    }
    const mime = (file.mimetype || '').toLowerCase();
    if (!DOCUMENT_ALLOWED_MIMES.includes(mime)) {
      throw new BadRequestException(
        `Invalid file type. Allowed: images (JPEG, PNG, WebP) or PDF.`,
      );
    }
    const ext = mime === DOCUMENT_PDF_MIME ? 'pdf' : mime.split('/')[1] || 'jpg';
    const safeName = (file.originalname || type)
      .replace(/[^a-zA-Z0-9.-]/g, '_')
      .slice(0, 40);
    const key = `partners/${partnerId}/documents/${type}/${Date.now()}-${safeName}.${ext}`;

    await s3.send(
      new sdk.PutObjectCommand({
        Bucket: this.bucket,
        Key: key,
        Body: file.buffer,
        ContentType: mime,
        ACL: 'public-read',
      }),
    );
    return `https://${this.bucket}.s3.${this.region}.amazonaws.com/${key}`;
  }
}
