import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/models/menu_item.dart';
import '../../shared/models/cart.dart' show SelectedOption;
import '../../shared/theme/app_colors.dart';
import '../../shared/utils/currency_formatter.dart';
import '../../l10n/app_localizations.dart';
import '../router/route_names.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final MenuItemModel item;
  final String restaurantName;

  const FoodDetailScreen({
    super.key,
    required this.item,
    required this.restaurantName,
  });

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  final Map<String, List<String>> _selectedOptions = {};
  final _instructionsController = TextEditingController();
  late AnimationController _btnAnimController;

  @override
  void initState() {
    super.initState();
    _btnAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );

    // Pre-select first option for required groups
    for (final group in widget.item.optionGroups) {
      if (group.required && group.options.isNotEmpty) {
        _selectedOptions[group.name] = [group.options.first.name];
      }
    }
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    _btnAnimController.dispose();
    super.dispose();
  }

  double get _totalPrice {
    final basePrice = widget.item.price * _quantity;
    double optionsPrice = 0;
    for (final entry in _selectedOptions.entries) {
      final group = widget.item.optionGroups.firstWhere(
        (g) => g.name == entry.key,
        orElse: () => ItemOptionGroup(name: entry.key),
      );
      for (final optionName in entry.value) {
        final option = group.options.firstWhere(
          (o) => o.name == optionName,
          orElse: () => ItemOption(name: optionName),
        );
        optionsPrice += option.price;
      }
    }
    return (basePrice + optionsPrice * _quantity);
  }

  void _handleAddToCart() {
    final l10n = AppLocalizations.of(context);
    // Validate required options
    for (final group in widget.item.optionGroups) {
      if (group.required) {
        final selected = _selectedOptions[group.name] ?? [];
        if (selected.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.foodRequired} ${group.name}'),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }
      }
    }

    final selectedOptionsList = <SelectedOption>[];
    for (final entry in _selectedOptions.entries) {
      for (final optionName in entry.value) {
        final group = widget.item.optionGroups.firstWhere(
          (g) => g.name == entry.key,
          orElse: () => ItemOptionGroup(name: entry.key),
        );
        final option = group.options.firstWhere(
          (o) => o.name == optionName,
          orElse: () => ItemOption(name: optionName),
        );
        selectedOptionsList.add(
          SelectedOption(
            groupName: entry.key,
            optionName: optionName,
            price: option.price,
            optionId: group.id,
            valueId: option.id,
          ),
        );
      }
    }

    _btnAnimController.reverse().then((_) {
      if (mounted) _btnAnimController.forward();
    });

    ref.read(cartProvider.notifier).addItem(
          item: widget.item,
          quantity: _quantity,
          selectedOptions: selectedOptionsList,
          specialInstructions: _instructionsController.text.isNotEmpty
              ? _instructionsController.text
              : null,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text('¡Agregaste $_quantity x ${widget.item.name} al carrito!'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00966B),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'VER CARRITO',
          textColor: const Color(0xFFFFD54F),
          onPressed: () => context.push(Routes.cart),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero Product Image AppBar
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: Colors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF1E2229),
                    ),
                    onPressed: () => context.pop(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product_hero_${widget.item.id}',
                    child: widget.item.imageUrl != null &&
                            widget.item.imageUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: widget.item.imageUrl!,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => _placeholder(),
                          )
                        : _placeholder(),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Speed badge + Category
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.bolt_rounded,
                                  size: 14,
                                  color: Color(0xFF007A55),
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'Entrega en 15 min',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF007A55),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.restaurantName.isNotEmpty
                                ? widget.restaurantName
                                : 'Plaza 4 Express',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Product Title
                      Text(
                        widget.item.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E2229),
                          letterSpacing: -0.4,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Price in PEN with savings tag
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            formatPen(context, widget.item.price),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF00966B),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formatPen(context, widget.item.price * 1.2),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF9E9E9E),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Precio Express',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFE65100),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Description
                      if (widget.item.description != null &&
                          widget.item.description!.isNotEmpty)
                        Text(
                          widget.item.description!,
                          style: const TextStyle(
                            fontSize: 13.5,
                            color: Color(0xFF555555),
                            height: 1.45,
                          ),
                        ),

                      const SizedBox(height: 20),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 16),

                      // Quantity Stepper
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cantidad',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E2229),
                                ),
                              ),
                              Text(
                                'Elige cuántas unidades llevar',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F6F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE0E0E0)),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_rounded),
                                  color: _quantity > 1
                                      ? const Color(0xFF00966B)
                                      : const Color(0xFFBDBDBD),
                                  onPressed: _quantity > 1
                                      ? () => setState(() => _quantity--)
                                      : null,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_rounded),
                                  color: const Color(0xFF00966B),
                                  onPressed: () =>
                                      setState(() => _quantity++),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Option groups
                      ...widget.item.optionGroups.map((group) {
                        return _buildOptionGroup(group);
                      }),

                      const SizedBox(height: 12),

                      // Instructions Note
                      const Text(
                        'Notas especiales para el pedido',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E2229),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _instructionsController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText:
                              'Ej. sin cebolla, papas bien doradas, palta madura...',
                          hintStyle: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF9E9E9E),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFFE5E7EB),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: ScaleTransition(
                  scale: _btnAnimController,
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _handleAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00966B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                formatPen(context, _totalPrice),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                '$_quantity ${_quantity == 1 ? "unidad" : "unidades"}',
                                style: const TextStyle(
                                  color: Color(0xFFD4EDDA),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                l10n.foodAddToCart,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionGroup(ItemOptionGroup group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                group.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2229),
                ),
              ),
              const SizedBox(width: 8),
              if (group.required)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Obligatorio',
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...group.options.map((option) {
            final isSelected =
                (_selectedOptions[group.name] ?? []).contains(option.name);

            return InkWell(
              onTap: () {
                setState(() {
                  if (group.required || group.type == 'single') {
                    _selectedOptions[group.name] = [option.name];
                  } else {
                    final current =
                        List<String>.from(_selectedOptions[group.name] ?? []);
                    if (current.contains(option.name)) {
                      current.remove(option.name);
                    } else {
                      current.add(option.name);
                    }
                    _selectedOptions[group.name] = current;
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: isSelected
                          ? const Color(0xFF00966B)
                          : const Color(0xFFBDBDBD),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFF1E2229)
                              : const Color(0xFF616161),
                        ),
                      ),
                    ),
                    if (option.price > 0)
                      Text(
                        '+ ${formatPen(context, option.price)}',
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF00966B),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFF3F4F6),
      child: const Center(
        child: Icon(
          Icons.fastfood_rounded,
          size: 64,
          color: Color(0xFFCBD5E1),
        ),
      ),
    );
  }
}
