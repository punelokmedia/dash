import { IsString, Matches,Length ,IsOptional,IsIn} from 'class-validator';

export class ContactDetailsDto {

   @IsString({ message: "Name must be a string" })
    @Length(2, 50, { message: "Name must be between 2 and 50 characters" })
    contactName: string

  @IsString()
@Matches(/^(?:\+91|91)?[6-9]\d{9}$/, {
  message: 'Phone number must be a valid Indian mobile number',
})
contactMobile: string;

  @IsOptional()
  @IsIn(['home', 'work', 'other'])
  saveAs?: 'home' | 'work' | 'other';
}