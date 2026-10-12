import esMessages from '../messages/es.json';
import viMessages from '../messages/vi.json';
import enMessages from '../messages/en.json';
import jaMessages from '../messages/ja.json';

export const locales = ['es', 'vi', 'en', 'ja'] as const;
export type Locale = (typeof locales)[number];
export const defaultLocale: Locale = 'es';

const allMessages = { es: esMessages, vi: viMessages, en: enMessages, ja: jaMessages };

/** Returns shared translation messages for the given locale. Falls back to es. */
export function getSharedMessages(locale: string) {
  return allMessages[locale as Locale] ?? allMessages.es;
}

export type SharedMessages = typeof esMessages;

export function getLocaleFromPathname(pathname: string): Locale | null {
  const locale = pathname.match(/^\/(es|vi|en|ja)(?:\/|$)/)?.[1];
  return locale && locales.includes(locale as Locale) ? (locale as Locale) : null;
}

export function stripLocalePrefix(pathname: string): string {
  const stripped = pathname.replace(/^\/(es|vi|en|ja)(?=\/|$)/, '');
  return stripped || '/';
}

export function localizePath(pathname: string, locale: Locale): string {
  const normalized = stripLocalePrefix(pathname);
  return normalized === '/' ? `/${locale}` : `/${locale}${normalized}`;
}
