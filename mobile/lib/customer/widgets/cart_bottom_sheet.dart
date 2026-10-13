import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../shared/providers/cart_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/utils/currency_formatter.dart';
import '../data/peru_seed_data.dart';
import '../router/route_names.dart';

/// Blinkit-style quick Cart Bottom Sheet.
///
/// Features an item list with quick steppers, tip selector,
/// transparent bill breakdown with S/ 6.00 delivery fee, savings banner,
/// and direct progression to Checkout.
class CartBottomSheet extends ConsumerStatefulWidget {
  const CartBottomSheet({super.key});

  @override
  ConsumerState<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends ConsumerState<CartBottomSheet> {
  double _tipAmount = 2.00;
  String _deliveryInstruction = 'Dejar en portería';

  final List<String> _instructions = [
    'Dejar en portería',
    'No tocar timbre (bebé duerme)',
    'Llamar al llegar',
    'Entrega sin contacto',
  ];

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final cart = cartState.currentCart;

    if (cart == null || cart.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 56,
              color: Color(0xFFBDC3C7),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tu carrito está vacío',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            const Text(
              '¡Agrega tus productos favoritos de Plaza 4 para pedir al toque!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 13),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Explorar productos'),
            ),
          ],
        ),
      );
    }

    final subtotal = cartState.subtotal;
    final deliveryFee = subtotal >= PeruSeedData.freeDeliveryThreshold
        ? 0.00
        : PeruSeedData.standardDeliveryFee;
    final ecoBag = PeruSeedData.ecoBagFee;
    final total = subtotal + deliveryFee + ecoBag + _tipAmount - cartState.discount;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.bolt_rounded,
                      color: Color(0xFF00A86B),
                      size: 22,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Entrega al toque en 15 min',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1E2229),
                          ),
                        ),
                        Text(
                          '${cart.itemCount} ${cart.itemCount == 1 ? "producto" : "productos"} en tu canasta',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7F8C8D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).clearCart();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Vaciar',
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Scrollable body
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                // Savings banner
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
                          '¡Estás ahorrando S/ 5.20 con precios exclusivos Plaza 4!',
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

                // Cart items list
                const Text(
                  'Tus productos',
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
                  return _buildItemRow(context, item, index);
                }),

                const SizedBox(height: 18),

                // Delivery instructions
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
                          color: isSelected ? Colors.white : const Color(0xFF424242),
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF00966B),
                      backgroundColor: const Color(0xFFF5F5F5),
                      onSelected: (val) {
                        if (val) setState(() => _deliveryInstruction = inst);
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Delivery partner tip
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
                          tip == 0.0 ? 'Sin propina' : 'S/ ${tip.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : const Color(0xFF424242),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF00966B),
                        backgroundColor: const Color(0xFFF5F5F5),
                        onSelected: (val) {
                          if (val) setState(() => _tipAmount = tip);
                        },
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 22),

                // Bill breakdown
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Desglose del pago',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E2229),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _billRow('Subtotal de productos', formatPen(context, subtotal)),
                      const SizedBox(height: 6),
                      _billRow(
                        'Costo de envío express',
                        deliveryFee == 0
                            ? 'GRATIS'
                            : formatPen(context, deliveryFee),
                        isHighlight: deliveryFee == 0,
                      ),
                      const SizedBox(height: 6),
                      _billRow('Bolsa biodegradable Plaza 4', formatPen(context, ecoBag)),
                      if (_tipAmount > 0) ...[
                        const SizedBox(height: 6),
                        _billRow('Propina voluntaria', formatPen(context, _tipAmount)),
                      ],
                      if (cartState.discount > 0) ...[
                        const SizedBox(height: 6),
                        _billRow(
                          'Descuento cupón',
                          '-${formatPen(context, cartState.discount)}',
                          isHighlight: true,
                        ),
                      ],
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: Color(0xFFE0E0E0)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total a pagar',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E2229),
                            ),
                          ),
                          Text(
                            formatPen(context, total),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF00966B),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),

          // Bottom sticky action button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.push(Routes.checkout);
                  },
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
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Text(
                            'Pagar con Yape, Plin o Efectivo',
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
                              fontSize: 14,
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
        ],
      ),
    );
  }

  Widget _buildItemRow(BuildContext context, dynamic item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 52,
              height: 52,
              child: item.menuItem.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: item.menuItem.imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => _itemPlaceholder(),
                    )
                  : _itemPlaceholder(),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E2229),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  formatPen(context, item.unitPrice),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),

          // Stepper
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF00966B)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    ref.read(cartProvider.notifier).updateItemQuantity(
                          index,
                          item.quantity - 1,
                        );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Icon(
                      Icons.remove_rounded,
                      size: 15,
                      color: Color(0xFF00966B),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 12.5,
                      color: Color(0xFF00966B),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    ref.read(cartProvider.notifier).updateItemQuantity(
                          index,
                          item.quantity + 1,
                        );
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Icon(
                      Icons.add_rounded,
                      size: 15,
                      color: Color(0xFF00966B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            fontSize: 12.5,
            color: isHighlight ? const Color(0xFF2E7D32) : const Color(0xFF616161),
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            color: isHighlight ? const Color(0xFF2E7D32) : const Color(0xFF212121),
            fontWeight: isHighlight ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _itemPlaceholder() {
    return Container(
      color: const Color(0xFFECEFF1),
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: Color(0xFFB0BEC5),
        size: 24,
      ),
    );
  }
}
