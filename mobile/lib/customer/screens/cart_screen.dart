import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/utils/currency_formatter.dart';
import '../../l10n/app_localizations.dart';
import '../data/peru_seed_data.dart';
import '../router/route_names.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _promoController = TextEditingController();
  bool _isApplyingPromo = false;
  double _tipAmount = 2.00;
  String _deliveryInstruction = 'Dejar en portería';

  final List<String> _instructions = [
    'Dejar en portería',
    'No tocar timbre (bebé duerme)',
    'Llamar al llegar',
    'Entrega sin contacto',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!ref.read(cartProvider).isEmpty) {
        return ref.read(cartProvider.notifier).fetchDeliveryPricing();
      }
    });
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  Future<void> _applyPromo() async {
    final code = _promoController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isApplyingPromo = true);
    await ref.read(cartProvider.notifier).applyPromoCode(code);
    if (mounted) setState(() => _isApplyingPromo = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cartState = ref.watch(cartProvider);

    if (cartState.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.cartTitle)),
        body: EmptyState(
          icon: Icons.shopping_cart_outlined,
          title: l10n.cartEmpty,
          subtitle: l10n.cartEmptySubtitle,
        ),
      );
    }

    final cart = cartState.currentCart!;
    final subtotal = cartState.subtotal;
    final deliveryFee = subtotal >= PeruSeedData.freeDeliveryThreshold
        ? 0.00
        : PeruSeedData.standardDeliveryFee;
    final ecoBag = PeruSeedData.ecoBagFee;
    final total =
        subtotal + deliveryFee + ecoBag + _tipAmount - cartState.discount;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E2229)),
          onPressed: () => context.pop(),
        ),
        title: Column(
          children: [
            Text(
              l10n.cartTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E2229),
              ),
            ),
            const Text(
              'Entrega express al toque en 15 min',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF00966B),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.cartClearTitle),
                  content: Text(l10n.cartClearContent),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.cartKeep),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).clearCart();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        l10n.cartDelete,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              l10n.cartClearAll,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Peruvian savings banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFC8E6C9)),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.celebration_rounded,
                          color: Color(0xFF2E7D32),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '¡Estás ahorrando S/ 5.20 con precios directos de Plaza 4!',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Store Header
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00966B).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.storefront_rounded,
                            color: Color(0xFF00966B),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Plaza 4 Express Miraflores',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: Color(0xFF1E2229),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Abarrotes • Comida caliente • Frutas',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '15 min',
                            style: TextStyle(
                              color: Color(0xFF007A55),
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Items
                  const Text(
                    'Productos en tu pedido',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E2229),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ...cart.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return CartItemTile(
                      item: item,
                      index: index,
                      onRemove: () =>
                          ref.read(cartProvider.notifier).removeItem(index),
                      onQuantityChanged: (qty) => ref
                          .read(cartProvider.notifier)
                          .updateItemQuantity(index, qty),
                    );
                  }),

                  const SizedBox(height: 16),

                  // Delivery Instructions
                  const Text(
                    'Instrucciones de entrega para el repartidor',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E2229),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _instructions.map((inst) {
                      final isSelected = _deliveryInstruction == inst;
                      return ChoiceChip(
                        label: Text(
                          inst,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF424242),
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF00966B),
                        backgroundColor: Colors.white,
                        onSelected: (val) {
                          if (val) setState(() => _deliveryInstruction = inst);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Tip Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Propina para el repartidor',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E2229),
                            ),
                          ),
                          Text(
                            'El 100% de la propina va directo a tu repartidor',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.two_wheeler_rounded,
                        color: Color(0xFF00966B),
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [0.0, 2.0, 4.0, 6.0].map((tip) {
                      final isSelected = _tipAmount == tip;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(
                            tip == 0.0
                                ? 'Sin propina'
                                : 'S/ ${tip.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF424242),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: const Color(0xFF00966B),
                          backgroundColor: Colors.white,
                          onSelected: (val) {
                            if (val) setState(() => _tipAmount = tip);
                          },
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Promo Code Input
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.discount_outlined,
                          color: Color(0xFF00966B),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _promoController,
                            decoration: const InputDecoration(
                              hintText: 'Ingresa cupón de descuento',
                              hintStyle: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF9E9E9E),
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _isApplyingPromo ? null : _applyPromo,
                          child: _isApplyingPromo
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Aplicar',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF00966B),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Bill Breakdown
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Detalle del pago',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E2229),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _billRow(
                          'Subtotal de productos',
                          formatPen(context, subtotal),
                        ),
                        const SizedBox(height: 8),
                        _billRow(
                          'Costo de envío express',
                          deliveryFee == 0
                              ? 'GRATIS'
                              : formatPen(context, deliveryFee),
                          isHighlight: deliveryFee == 0,
                        ),
                        const SizedBox(height: 8),
                        _billRow(
                          'Bolsa ecológica Plaza 4',
                          formatPen(context, ecoBag),
                        ),
                        if (_tipAmount > 0) ...[
                          const SizedBox(height: 8),
                          _billRow(
                            'Propina al repartidor',
                            formatPen(context, _tipAmount),
                          ),
                        ],
                        if (cartState.discount > 0) ...[
                          const SizedBox(height: 8),
                          _billRow(
                            'Descuento aplicado',
                            '-${formatPen(context, cartState.discount)}',
                            isHighlight: true,
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total a pagar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E2229),
                              ),
                            ),
                            Text(
                              formatPen(context, total),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF00966B),
                                letterSpacing: -0.4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.push(Routes.checkout),
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
                        formatPen(context, total),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Text(
                        'Total con impuestos y envío',
                        style: TextStyle(
                          color: Color(0xFFD4EDDA),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      Text(
                        'Continuar al Pago',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _billRow(String label, String value, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isHighlight
                ? const Color(0xFF2E7D32)
                : const Color(0xFF616161),
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: isHighlight
                ? const Color(0xFF2E7D32)
                : const Color(0xFF212121),
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
