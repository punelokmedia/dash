import { MulterFile } from '@/types/multer';
import { Injectable } from '@nestjs/common';
import { v2 as cloudinary } from 'cloudinary';
import { Readable } from 'stream';


@Injectable()
export class CloudinaryService {
  constructor() {
    cloudinary.config({
      cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
      api_key: process.env.CLOUDINARY_API_KEY,
      api_secret: process.env.CLOUDINARY_API_SECRET,
    });
  }

  async uploadFile(
    file: MulterFile,
    folder: string,
    publicId: string,
  ): Promise<string> {
    return new Promise((resolve, reject) => {
  const uploadStream = cloudinary.uploader.upload_stream(
    {
      folder,
      public_id: publicId,
    },
    (error, result) => {
      if (error) return reject(error);

      if (!result?.secure_url) {
        return reject(new Error('Cloudinary upload failed'));
      }

      resolve(result.secure_url);
    },
  );

  Readable.from(file.buffer).pipe(uploadStream);
});
  }
}