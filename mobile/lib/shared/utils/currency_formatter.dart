import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String penCurrencySymbol(BuildContext context) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return NumberFormat.simpleCurrency(
    name: 'PEN',
    locale: locale,
  ).currencySymbol;
}

String formatPen(BuildContext context, num amount) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return NumberFormat.currency(
    locale: locale,
    symbol: 'S/',
    decimalDigits: 2,
  ).format(amount);
}

String formatSignedPen(BuildContext context, num amount) {
  final formatted = formatPen(context, amount.abs());
  if (amount > 0) return '+$formatted';
  if (amount < 0) return '-$formatted';
  return formatted;
}
