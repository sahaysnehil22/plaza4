import type { Metadata } from 'next';
import './globals.css';
import 'maplibre-gl/dist/maplibre-gl.css';
import { NextIntlClientProvider } from 'next-intl';
import { getLocale, getMessages } from 'next-intl/server';
import { resolveAdminMetadataBase } from '@/lib/metadata-url';

export const metadata: Metadata = {
  metadataBase: resolveAdminMetadataBase(),
  title: {
    template: '%s | Plaza 4 Admin',
    default: 'Plaza 4 Admin',
  },
  description: 'Plaza 4 delivery operations console for orders, restaurants, drivers, and users',
  manifest: '/site.webmanifest',
  icons: {
    icon: [
      { url: '/favicon.svg', type: 'image/svg+xml' },
      { url: '/plaza4-mark.svg', type: 'image/svg+xml', sizes: 'any' },
    ],
  },
  openGraph: {
    title: 'Plaza 4 Admin',
    description: 'Plaza 4 delivery operations console',
    type: 'website',
    images: [{ url: '/plaza4-mark.svg', width: 512, height: 512, alt: 'Plaza 4 Admin mark' }],
  },
  twitter: { card: 'summary', title: 'Plaza 4 Admin', images: ['/plaza4-mark.svg'] },
  robots: { index: false, follow: false },
};

export default async function RootLayout({ children }: { children: React.ReactNode }) {
  const [locale, messages] = await Promise.all([getLocale(), getMessages()]);

  return (
    <html lang={locale}>
      <body className="font-sans antialiased">
        <NextIntlClientProvider locale={locale} messages={messages}>
          {children}
        </NextIntlClientProvider>
      </body>
    </html>
  );
}
