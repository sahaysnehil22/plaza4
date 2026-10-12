import 'package:flutter_test/flutter_test.dart';
import 'package:plaza4_customer/customer/router/deep_link_parser.dart';
import 'package:plaza4_customer/customer/router/route_names.dart';

void main() {
  group('DeepLinkParser B-MOB-09', () {
    test('maps plaza4://orders/{id} to order-tracking with extra', () {
      final parsed = DeepLinkParser.parseWithExtras(
        'plaza4://orders/order-abc',
      );
      expect(parsed, isNotNull);
      expect(parsed!.path, Routes.orderTracking);
      expect(parsed.extra, 'order-abc');
    });

    test('maps plaza4://order/{id} to order-tracking with extra', () {
      final parsed = DeepLinkParser.parseWithExtras(
        'plaza4://order/order-xyz',
      );
      expect(parsed, isNotNull);
      expect(parsed!.path, Routes.orderTracking);
      expect(parsed.extra, 'order-xyz');
    });

    test('maps https://plaza4.pe/orders/{id}', () {
      final parsed = DeepLinkParser.parseWithExtras(
        'https://plaza4.pe/orders/order-99',
      );
      expect(parsed, isNotNull);
      expect(parsed!.path, Routes.orderTracking);
      expect(parsed.extra, 'order-99');
    });

    test('parse() returns order tracking path for /orders/{id}', () {
      expect(
        DeepLinkParser.parse('plaza4://orders/o1'),
        Routes.orderTracking,
      );
    });
  });
}
