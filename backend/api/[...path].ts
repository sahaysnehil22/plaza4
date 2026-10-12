import type { IncomingMessage, ServerResponse } from 'http'
import { createPlaza4App } from '../src/bootstrap/create-plaza4-app'

type ExpressHandler = (req: IncomingMessage, res: ServerResponse) => void

let cachedHandler: ExpressHandler | null = null

async function getHandler(): Promise<ExpressHandler> {
  if (!cachedHandler) {
    const app = await createPlaza4App({
      enableWebSockets: false,
      setupSwagger: process.env.NODE_ENV !== 'production',
    })
    await app.init()
    cachedHandler = app.getHttpAdapter().getInstance() as ExpressHandler
  }
  return cachedHandler
}

export default async function handler(req: IncomingMessage, res: ServerResponse) {
  const expressHandler = await getHandler()
  return expressHandler(req, res)
}
