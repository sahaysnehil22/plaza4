import { redirect } from 'next/navigation';
import { defaultLocale } from '@plaza4/i18n';

export default function HomePage() {
  redirect(`/${defaultLocale}`);
}
