/**
 * Multer file type – compatible with Express.Multer.File.
 * Use this instead of Express.Multer.File to avoid global namespace issues.
 */
export interface MulterFile {
  fieldname: string;
  originalname: string;
  encoding: string;
  mimetype: string;
  size: number;
  buffer: Buffer;
}
