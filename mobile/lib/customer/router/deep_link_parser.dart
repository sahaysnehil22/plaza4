import 'route_names.dart';

/// Parses deep link URIs (plaza4:// and https://plaza4.pe/) into route paths.
class DeepLinkParser {
  DeepLinkParser._();

  /// Parse a deep link string and return the matching go_router location.
  ///
  /// Returns null if the URI doesn't match any known pattern.
  static String? parse(String uriString) {
    final uri = Uri.tryParse(uriString);
    if (uri == null) return null;

    // Handle plaza4:// scheme
    if (uri.scheme == DeepLinkScheme.plaza4) {
      return _parsePlaza4Link(uri);
    }

    // Handle https://plaza4.pe scheme
    if (uri.scheme == DeepLinkScheme.https && uri.host == 'plaza4.pe') {
      return _parseHttpsLink(uri);
    }

    return null;
  }

  /// plaza4://orders/id has host=`orders` and path=`/id`.
  /// plaza4:///orders/id has empty host and path=`/orders/id`.
  static List<String> _segments(Uri uri) {
    if (uri.scheme == DeepLinkScheme.plaza4) {
      final segments = <String>[];
      if (uri.host.isNotEmpty) {
        segments.add(uri.host);
      }
      segments.addAll(uri.pathSegments);
      return segments;
    }
    return uri.pathSegments;
  }

  static String? _parsePlaza4Link(Uri uri) {
    final pathSegments = _segments(uri);
    if (pathSegments.isEmpty) return null;

    switch (pathSegments[0]) {
      // B-MOB-09: support both /order/{id} and /orders/{id}
      case 'order':
      case 'orders':
        if (pathSegments.length >= 2) {
          return Routes.orderTracking;
        }
        return null;
      case 'restaurant':
        if (pathSegments.length >= 2) {
          return Routes.restaurantDetail;
        }
        return null;
      case 'promo':
        if (pathSegments.length >= 2) {
          return Routes.vouchers;
        }
        return null;
      default:
        return null;
    }
  }

  static String? _parseHttpsLink(Uri uri) {
    return _parsePlaza4Link(uri);
  }

  /// Parse a route and build path with extras for GoRouter.
  static ({String path, Object? extra})? parseWithExtras(String uriString) {
    final uri = Uri.tryParse(uriString);
    if (uri == null) return null;

    final scheme = uri.scheme;
    if (scheme != DeepLinkScheme.plaza4 &&
        !(scheme == DeepLinkScheme.https && uri.host == 'plaza4.pe')) {
      return null;
    }

    final pathSegments = _segments(uri);
    if (pathSegments.isEmpty) return null;

    switch (pathSegments[0]) {
      // B-MOB-09: map /orders/{id} → order-tracking with orderId extra.
      case 'order':
      case 'orders':
        if (pathSegments.length >= 2) {
          return (path: Routes.orderTracking, extra: pathSegments[1]);
        }
        break;
      case 'restaurant':
        if (pathSegments.length >= 2) {
          return (path: Routes.restaurantDetail, extra: pathSegments[1]);
        }
        break;
      case 'promo':
        if (pathSegments.length >= 2) {
          return (path: Routes.vouchers, extra: null);
        }
        break;
    }

    return null;
  }
}
