/**
 * Application configuration factory
 * Loads from environment variables
 */
export default () => ({
  port: parseInt(process.env.PORT || '3000', 10),
  env: process.env.NODE_ENV || 'development',
  jwt: {
    secret: process.env.JWT_SECRET || 'change-me-in-production',
    expiresIn: process.env.JWT_EXPIRES_IN || '7d',
  },
  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT || '6379', 10),
    password: process.env.REDIS_PASSWORD || undefined,
    otpPrefix: 'otp:',
    otpExpirySeconds: 300, // 5 minutes
  },
  otp: {
    length: 6,
    expiryMinutes: 5,
  },
  /** Development → console + dev_otp. Production → MSG91 only. */
  otpDelivery: {
    isProduction: process.env.NODE_ENV === 'production',
  },
  msg91: {
    authKey: process.env.MSG91_AUTH_KEY || '',
    senderId: process.env.MSG91_SENDER_ID || 'DELIVR',
    otpExpiryMinutes: parseInt(process.env.MSG91_OTP_EXPIRY_MINUTES || '5', 10),
  },
  admin: {
    apiKey: process.env.ADMIN_API_KEY || '',
  },
  superAdmin: {
    apiKey: process.env.SUPER_ADMIN_API_KEY || '',
  },
  aws: {
    region: process.env.AWS_REGION || 'ap-south-1',
    accessKeyId: process.env.AWS_ACCESS_KEY_ID || '',
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || '',
    s3Bucket: process.env.S3_BUCKET_NAME || '',
  },
  cld: {
    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET,
  },
  
});
