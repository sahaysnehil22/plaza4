import { Injectable, ServiceUnavailableException } from '@nestjs/common'
import { ConfigService } from '@nestjs/config'

@Injectable()
export class DeliveryPricingService {
  constructor(private readonly config: ConfigService) {}

  getBaseDeliveryFeePen(): number {
    const fee = this.config.get<number>('DELIVERY_BASE_FEE_PEN')
    if (typeof fee !== 'number' || !Number.isInteger(fee) || fee < 0) {
      throw new ServiceUnavailableException('DELIVERY_PRICING_NOT_CONFIGURED')
    }
    return fee
  }
}
