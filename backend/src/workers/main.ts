import { NestFactory } from '@nestjs/core'
import { WorkersModule } from './workers.module'

async function bootstrap() {
  const app = await NestFactory.createApplicationContext(WorkersModule)
  app.enableShutdownHooks()
  await app.init()
  console.log('Plaza 4 Worker started')
}

void bootstrap().catch(() => {
  console.error('Plaza 4 Worker failed to start')
  process.exitCode = 1
})
