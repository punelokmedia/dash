import {
Controller,
Post,
Get,
Patch,
Delete,
Param,
Body,
Req,
UseGuards
} from '@nestjs/common'

import { AddressService } from './address.service'
import { CreateAddressDto } from './dto/create-address.dto'
import { UpdateAddressDto } from './dto/update-address.dto'
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard'
import { ReverseGeocodeDto } from './dto/reverse-geocode.dto'

@Controller('addresses')
@UseGuards(JwtAuthGuard)
export class AddressController {

constructor(private addressService: AddressService) {}

@Post()
async create(@Req() req: any, @Body() dto: CreateAddressDto) {

const userId = req.user.id

return await this.addressService.create(userId, dto)

}

@Get()
findAll(@Req() req: any) {

const userId = req.user.id


return this.addressService.findAll(userId)

}

@Get(':id')
findOne(@Req() req: any, @Param('id') id: string) {

const userId = req.user.id

return this.addressService.findOne(userId, id)

}

@Patch(':id')
update(
@Req() req: any,
@Param('id') id: string,
@Body() dto: UpdateAddressDto
) {

const userId = req.user.id

return this.addressService.update(userId, id, dto)

}

@Delete(':id')
remove(
@Req() req: any,
@Param('id') id: string
) {

const userId = req.user.id

return this.addressService.remove(userId, id)

}

@Patch(':id/default')
setDefault(
@Req() req: any,
@Param('id') id: string
) {

const userId = req.user.id

return this.addressService.setDefault(userId, id)

}

@Post('reverse-geocode')
reverseGeocode(
@Req() req: any,
@Body() dto: ReverseGeocodeDto
) {

const userId = req.user.id

return this.addressService.reverseGeocode(dto)

}

}