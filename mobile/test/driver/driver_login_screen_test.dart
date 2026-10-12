import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plaza4_customer/driver/screens/login_screen.dart';
import 'package:plaza4_customer/l10n/app_localizations.dart';

Widget _app(Locale locale) {
  return ProviderScope(
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginScreen(),
    ),
  );
}

void main() {
  testWidgets('renders the canonical brand and localized driver login copy', (
    tester,
  ) async {
    const expectations = {
      'vi': ('Đăng nhập để bắt đầu nhận đơn giao hàng', 'Hiện mật khẩu'),
      'en': ('Sign in to start accepting deliveries', 'Show password'),
      'ja': ('ログインして配達依頼の受付を開始', 'パスワードを表示'),
    };

    for (final entry in expectations.entries) {
      await tester.pumpWidget(_app(Locale(entry.key)));
      await tester.pump();

      expect(find.bySemanticsLabel('Plaza 4'), findsOneWidget);
      expect(find.text('FoodFlow Driver'), findsOneWidget);
      expect(find.text(entry.value.$1), findsOneWidget);
      expect(find.byTooltip(entry.value.$2), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    }
  });
}
