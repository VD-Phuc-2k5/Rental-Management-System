import { Injectable, BadRequestException } from '@nestjs/common';
import { SupabaseService } from 'src/shared/infrastructure/supabase/supabase.service';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class UploadService {
  constructor(private readonly supabaseService: SupabaseService) {}

  async uploadImage(
    bucket: 'room-images' | 'identity-images' | 'maintenance-requests',
    fileBuffer: Buffer,
    mimeType: string,
  ): Promise<string> {
    const ext = mimeType.split('/')[1] ?? 'jpg';
    const path = `${uuidv4()}.${ext}`;

    const { error } = await this.supabaseService
      .getClient()
      .storage.from(bucket)
      .upload(path, fileBuffer, { contentType: mimeType, upsert: false });

    if (error) throw new BadRequestException(`Upload failed: ${error.message}`);

    const { data } = this.supabaseService
      .getClient()
      .storage.from(bucket)
      .getPublicUrl(path);

    return data.publicUrl;
  }
}
