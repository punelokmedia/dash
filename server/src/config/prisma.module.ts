import { Global, Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';
import { CloudinaryModule } from './cloudinary/cloudinary.module';
import { NodemailerModule } from './nodemailer/nodemailer.module';

@Global()
@Module({
  providers: [PrismaService],
  exports: [PrismaService],
  imports: [CloudinaryModule, NodemailerModule],
})
export class PrismaModule {}
