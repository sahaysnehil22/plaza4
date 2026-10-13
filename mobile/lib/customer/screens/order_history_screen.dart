import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../shared/providers/order_provider.dart';
import '../../shared/models/order.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_text_styles.dart';
import '../../shared/widgets/order_status_badge.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../../shared/widgets/error_state.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/utils/currency_formatter.dart';
import '../router/route_names.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).fetchOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final orderState = ref.watch(orderProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.orderHistoryTitle),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: [
            Tab(
              text: l10n.orderHistoryTabActive(orderState.activeOrders.length),
            ),
            Tab(
              text: l10n.orderHistoryTabCompleted(
                orderState.completedOrders.length,
              ),
            ),
            Tab(
              text: l10n.orderHistoryTabCancelled(
                orderState.cancelledOrders.length,
              ),
            ),
          ],
        ),
      ),
      body: orderState.isLoading
          ? const LoadingShimmer(type: ShimmerType.order, itemCount: 4)
          : orderState.error != null
          ? ErrorState(
              message: orderState.error!,
              onRetry: () => ref.read(orderProvider.notifier).fetchOrders(),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(orderState.activeOrders, 'active', l10n),
                _buildOrderList(orderState.completedOrders, 'completed', l10n),
                _buildOrderList(orderState.cancelledOrders, 'cancelled', l10n),
              ],
            ),
    );
  }

  Widget _buildOrderList(
    List<OrderModel> orders,
    String type,
    AppLocalizations l10n,
  ) {
    if (orders.isEmpty) {
      String message;
      IconData icon;
      switch (type) {
        case 'active':
          message = l10n.orderHistoryNoActive;
          icon = Icons.receipt_long_outlined;
          break;
        case 'completed':
          message = l10n.orderHistoryNoCompleted;
          icon = Icons.check_circle_outline;
          break;
        default:
          message = l10n.orderHistoryNoCancelled;
          icon = Icons.cancel_outlined;
      }
      return EmptyState(
        icon: icon,
        title: message,
        subtitle: l10n.orderHistoryEmptySubtitle,
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(orderProvider.notifier).fetchOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) => _buildOrderCard(orders[index]),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return GestureDetector(
      onTap: () {
        if (order.isActive) {
          context.push(Routes.orderTracking, extra: order.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.restaurantName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order.items.length} ${order.items.length == 1 ? "ítem" : "ítems"} • ${formatPen(context, order.total)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF00966B),
                        ),
                      ),
                    ],
                  ),
                ),
                OrderStatusBadge(status: order.status),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              order.items
                  .map((item) => '${item.name} (x${item.quantity})')
                  .join(', '),
              style: AppTextStyles.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time_rounded, size: 14, color: AppColors.textHint),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(order.createdAt),
                  style: AppTextStyles.caption,
                ),
                const Spacer(),
                if (order.isActive)
                  ElevatedButton(
                    onPressed: () =>
                        context.push(Routes.orderTracking, extra: order.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00966B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context).orderHistoryTrack,
                      style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                    ),
                  )
                else if (order.status == 'delivered')
                  TextButton(
                    onPressed: () =>
                        context.push(Routes.review, extra: order.id),
                    child: const Text(
                      'Calificar',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00966B),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
