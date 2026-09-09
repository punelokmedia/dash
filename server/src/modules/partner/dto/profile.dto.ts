import {
  IsOptional,
  IsString,
  MaxLength,
  MinLength,
  IsUrl,
  ValidateIf,
} from 'class-validator';

/**
 * DTO for updating partner profile (full name, profile photo).
 */
export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @MinLength(2, { message: 'Full name must be at least 2 characters' })
  @MaxLength(100)
  full_name?: string;

  @IsOptional()
  @ValidateIf((_, v) => v != null && v !== '')
  @IsString()
  @IsUrl({}, { message: 'Profile photo must be a valid URL' })
  profile_photo?: string;
}
