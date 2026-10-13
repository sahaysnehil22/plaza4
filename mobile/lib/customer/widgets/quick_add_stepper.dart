import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/menu_item.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/theme/app_colors.dart';

/// Blinkit-style interactive Quick-Add Stepper button.
///
/// If quantity is 0, renders a high-contrast "+ AÑADIR" pill button.
/// When tapped or when items exist in the cart, morphs smoothly into
/// a compact Stepper `[-]  [qty]  [+]` with tactile bounce and haptic response.
class QuickAddStepper extends ConsumerStatefulWidget {
  final MenuItemModel item;
  final bool compact;
  final VoidCallback? onAdded;

  const QuickAddStepper({
    super.key,
    required this.item,
    this.compact = false,
    this.onAdded,
  });

  @override
  ConsumerState<QuickAddStepper> createState() => _QuickAddStepperState();
}

class _QuickAddStepperState extends ConsumerState<QuickAddStepper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0.90,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _triggerBounce() {
    _animController.reverse().then((_) {
      if (mounted) _animController.forward();
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cart = cartState.currentCart;

    // Find all matching cart lines for this menu item
    int currentQty = 0;
    int? itemIndex;
    if (cart != null) {
      for (int i = 0; i < cart.items.length; i++) {
        if (cart.items[i].menuItem.id == widget.item.id) {
          currentQty += cart.items[i].quantity;
          itemIndex = i;
        }
      }
    }

    final hasQuantity = currentQty > 0;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        height: widget.compact ? 32 : 36,
        decoration: BoxDecoration(
          color: hasQuantity ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: hasQuantity ? AppColors.primary : AppColors.primary,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: hasQuantity
                  ? AppColors.primary.withValues(alpha: 0.28)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: hasQuantity
              ? _buildStepper(context, currentQty, itemIndex!)
              : _buildAddButton(context),
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      key: const ValueKey('btn_add'),
      onTap: () {
        _triggerBounce();
        ref.read(cartProvider.notifier).addItem(
              item: widget.item,
              quantity: 1,
            );
        widget.onAdded?.call();
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.compact ? 10 : 14,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_rounded,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'AÑADIR',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                fontSize: widget.compact ? 11 : 12.5,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(BuildContext context, int quantity, int index) {
    return Row(
      key: const ValueKey('stepper_active'),
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Decrement button
        InkWell(
          onTap: () {
            _triggerBounce();
            ref.read(cartProvider.notifier).updateItemQuantity(
                  index,
                  quantity - 1,
                );
          },
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 6 : 8,
              vertical: 4,
            ),
            child: const Icon(
              Icons.remove_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
        // Quantity display
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.compact ? 6 : 8,
          ),
          child: Text(
            '$quantity',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: widget.compact ? 12 : 13.5,
            ),
          ),
        ),
        // Increment button
        InkWell(
          onTap: () {
            _triggerBounce();
            ref.read(cartProvider.notifier).updateItemQuantity(
                  index,
                  quantity + 1,
                );
            widget.onAdded?.call();
          },
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? 6 : 8,
              vertical: 4,
            ),
            child: const Icon(
              Icons.add_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
