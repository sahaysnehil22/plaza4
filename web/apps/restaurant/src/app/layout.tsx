import type { Metadata } from 'next'
import { NextIntlClientProvider } from 'next-intl'
import { getLocale, getMessages } from 'next-intl/server'
import './globals.css'
import 'maplibre-gl/dist/maplibre-gl.css'
import { resolveRestaurantMetadataBase } from '@/lib/metadata-url'

export const metadata: Metadata = {
  metadataBase: resolveRestaurantMetadataBase(),
  title: {
    template: '%s | Plaza 4 Restaurant',
    default: 'Plaza 4 Restaurant',
  },
  description: 'Plaza 4 merchant workspace for orders, menu, promotions, revenue, staff, insights, and customer replies',
  manifest: '/site.webmanifest',
  icons: {
    icon: [
      { url: '/favicon.svg', type: 'image/svg+xml' },
      { url: '/plaza4-mark.svg', type: 'image/svg+xml', sizes: 'any' },
    ],
  },
  openGraph: {
    title: 'Plaza 4 Restaurant',
    description: 'Plaza 4 merchant workspace',
    type: 'website',
    images: [{ url: '/plaza4-mark.svg', width: 512, height: 512, alt: 'Plaza 4 Restaurant mark' }],
  },
  twitter: { card: 'summary', title: 'Plaza 4 Restaurant', images: ['/plaza4-mark.svg'] },
}

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  const [locale, messages] = await Promise.all([getLocale(), getMessages()])

  return (
    <html lang={locale}>
      <body className="font-sans antialiased">
        <NextIntlClientProvider locale={locale} messages={messages}>
          {children}
        </NextIntlClientProvider>
      </body>
    </html>
  )
}
