import { IsBoolean, IsString } from "class-validator";

export class ToggleStatusDTO {
  @IsString()
  id: string;

  @IsBoolean()
  isActive: boolean;
}