import { getRequestConfig } from 'next-intl/server';
import { getSharedMessages, locales, defaultLocale } from '@plaza4/i18n';
import type { Locale } from '@plaza4/i18n';
import esMessages from '../messages/es.json';
import viMessages from '../messages/vi.json';
import enMessages from '../messages/en.json';
import jaMessages from '../messages/ja.json';

const appMessages = {
  es: esMessages,
  vi: viMessages,
  en: enMessages,
  ja: jaMessages,
} as const;

/**
 * next-intl request config for the restaurant app.
 * Merges shared (@plaza4/i18n) messages with restaurant-specific messages.
 */
export default getRequestConfig(async ({ requestLocale }) => {
  const locale = await requestLocale;
  const safeLocale: Locale = (locales as readonly string[]).includes(locale ?? '')
    ? (locale as Locale)
    : defaultLocale;

  return {
    locale: safeLocale,
    messages: {
      ...getSharedMessages(safeLocale),
      ...appMessages[safeLocale],
    },
  };
});
