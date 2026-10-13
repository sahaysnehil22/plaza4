import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../shared/models/menu_item.dart';
import '../../shared/utils/currency_formatter.dart';
import '../router/route_names.dart';
import 'quick_add_stepper.dart';

/// High-density quick-commerce product card optimized for Peruvian quick-commerce.
///
/// Displays product thumbnail with Hero transition, delivery time tag,
/// PEN prices formatted according to Peruvian conventions, discount badges,
/// and the interactive [QuickAddStepper].
class PlazaProductCard extends StatelessWidget {
  final MenuItemModel item;
  final double? originalPrice;
  final String? unitLabel;
  final String? discountTag;
  final VoidCallback? onAddToCart;
  final double width;

  const PlazaProductCard({
    super.key,
    required this.item,
    this.originalPrice,
    this.unitLabel,
    this.discountTag,
    this.onAddToCart,
    this.width = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push(
              Routes.foodDetail,
              extra: {
                'item': item,
                'restaurantName': 'Plaza 4 Express',
              },
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top section: Image + badges
                Stack(
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 110,
                        width: double.infinity,
                        color: const Color(0xFFF8F9FA),
                        child: Hero(
                          tag: 'product_hero_${item.id}',
                          child: item.imageUrl != null &&
                                  item.imageUrl!.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: item.imageUrl!,
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => _placeholder(),
                                  errorWidget: (_, __, ___) => _placeholder(),
                                )
                              : _placeholder(),
                        ),
                      ),
                    ),

                    // ETA / Speed badge
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.72),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              size: 11,
                              color: Color(0xFFFFD54F),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '15 min',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Discount tag if available
                    if (discountTag != null)
                      Positioned(
                        bottom: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE53935), Color(0xFFFF5722)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            discountTag!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Unit / weight hint
                Text(
                  unitLabel ?? _inferUnit(item.name),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 3),

                // Product title
                SizedBox(
                  height: 34,
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E2229),
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                const SizedBox(height: 8),

                // Bottom row: Price and Stepper
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Price column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (originalPrice != null &&
                              originalPrice! > item.price)
                            Text(
                              formatPen(context, originalPrice!),
                              style: const TextStyle(
                                fontSize: 10.5,
                                color: Color(0xFF9E9E9E),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            formatPen(context, item.price),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1A1A1A),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Quick-add Stepper
                    QuickAddStepper(
                      item: item,
                      compact: true,
                      onAdded: onAddToCart,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _inferUnit(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('1.5l')) return '1.5 Litros';
    if (lower.contains('1l')) return '1 Litro';
    if (lower.contains('1 kg') || lower.contains('1kg')) return '1 Kilogramo';
    if (lower.contains('500g') || lower.contains('500 g')) return '500 gramos';
    if (lower.contains('x 10')) return 'Pack x 10 und';
    if (lower.contains('x 6')) return 'Pack x 6 und';
    if (lower.contains('1/4')) return '1/4 porción con guarnición';
    if (lower.contains('lomo')) return 'Porción completa + papas';
    if (lower.contains('arroz chaufa')) return 'Porción al wok';
    return 'Unidad';
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: const Center(
        child: Icon(
          Icons.shopping_bag_outlined,
          size: 32,
          color: Color(0xFFBDC3C7),
        ),
      ),
    );
  }
}
