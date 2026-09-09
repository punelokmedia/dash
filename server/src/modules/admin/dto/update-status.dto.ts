import { IsIn, IsNotEmpty, IsString } from 'class-validator';

/**
 * DTO for admin partner status update
 */
export class UpdatePartnerStatusDto {
  @IsNotEmpty()
  @IsString()
  partner_id: string;

  @IsIn(['pending', 'approved', 'rejected'], {
    message: 'Status must be one of: pending, approved, rejected',
  })
  status: 'pending' | 'approved' | 'rejected';
}
