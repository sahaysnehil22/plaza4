import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/utils/currency_formatter.dart';
import '../router/route_names.dart';
import 'cart_bottom_sheet.dart';

/// Blinkit-style persistent floating cart bar.
///
/// Appears smoothly at the bottom of screens when items exist in the cart.
/// Features a scale bump animation when items are added, shows item count,
/// subtotal in PEN, and quick access to the Cart Bottom Sheet or Cart Screen.
class FloatingCartBar extends ConsumerStatefulWidget {
  final bool openAsSheet;

  const FloatingCartBar({super.key, this.openAsSheet = true});

  @override
  ConsumerState<FloatingCartBar> createState() => _FloatingCartBarState();
}

class _FloatingCartBarState extends ConsumerState<FloatingCartBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _bumpController;
  int _lastItemCount = 0;

  @override
  void initState() {
    super.initState();
    _bumpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      lowerBound: 0.96,
      upperBound: 1.04,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _bumpController.dispose();
    super.dispose();
  }

  void _triggerBump() {
    _bumpController.forward().then((_) {
      if (mounted) _bumpController.reverse();
    });
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final count = cartState.totalItemCount;

    if (count > _lastItemCount && _lastItemCount != 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _triggerBump());
    }
    _lastItemCount = count;

    if (count == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: ScaleTransition(
        scale: _bumpController,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00966B), Color(0xFF007A55)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00966B).withValues(alpha: 0.38),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (widget.openAsSheet) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const CartBottomSheet(),
                  );
                } else {
                  context.push(Routes.cart);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // Badge and count
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shopping_bag_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$count ${count == 1 ? "ítem" : "ítems"}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Subtotal price
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            formatPen(context, cartState.subtotal),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const Text(
                            'S/ 6.00 envío • 15 min',
                            style: TextStyle(
                              color: Color(0xFFD4EDDA),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // "Ver Carrito" action
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ver Carrito',
                            style: TextStyle(
                              color: Color(0xFF007A55),
                              fontWeight: FontWeight.w800,
                              fontSize: 12.5,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Color(0xFF007A55),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
