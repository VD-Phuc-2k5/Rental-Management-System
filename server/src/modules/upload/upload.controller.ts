import {
  Controller,
  Post,
  Query,
  UploadedFile,
  UseGuards,
  UseInterceptors,
  BadRequestException,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiConsumes, ApiTags } from '@nestjs/swagger';
import { AuthGuard } from 'src/shared/common/guards/auth.guard';
import { UploadService } from './upload.service';

@ApiTags('upload')
@Controller('upload')
@UseGuards(AuthGuard)
export class UploadController {
  constructor(private readonly uploadService: UploadService) {}

  @Post('image')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('file'))
  async uploadImage(
    @UploadedFile() file: Express.Multer.File,
    @Query('bucket') bucket: string,
  ) {
    if (!file) throw new BadRequestException('No file provided');
    const validBuckets = ['room-images', 'identity-images'] as const;
    const targetBucket = validBuckets.includes(bucket as any)
      ? (bucket as 'room-images' | 'identity-images')
      : 'room-images';

    const url = await this.uploadService.uploadImage(
      targetBucket,
      file.buffer,
      file.mimetype,
    );
    return { url };
  }
}
