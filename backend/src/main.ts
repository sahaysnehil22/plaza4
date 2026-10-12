import { ConfigService } from '@nestjs/config'
import { createPlaza4App } from './bootstrap/create-plaza4-app'

async function bootstrap() {
  const app = await createPlaza4App({
    enableWebSockets: process.env.REALTIME_PROVIDER !== 'supabase',
  })
  const configService = app.get(ConfigService)
  const port = configService.get<number>('PORT')
  if (!port) throw new Error('PORT environment variable is not set')

  await app.listen(port)
  console.log(`Plaza 4 API listening on port ${port}`)
}

bootstrap()
