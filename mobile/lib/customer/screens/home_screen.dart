import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:geolocator/geolocator.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/restaurant_provider.dart';
import '../../shared/providers/auth_provider.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/restaurant_card.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/utils/app_error_messages.dart';
import '../providers/vouchers_provider.dart';
import '../widgets/promo_banner.dart';
import '../widgets/plaza_product_card.dart';
import '../widgets/floating_cart_bar.dart';
import '../widgets/peruvian_quick_commerce_shimmer.dart';
import '../data/peru_seed_data.dart';
import '../router/route_names.dart';
import 'category_browse_screen.dart';

/// Helper required and tested by unit tests in `home-location-privacy-label-test.dart`.
String customerHomeLocationLabel(
  AppLocalizations localizations, {
  required bool hasLocation,
}) => hasLocation ? localizations.currentLocationLabel : localizations.locating;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Position? _currentLocation;
  int _searchHintIndex = 0;
  Timer? _searchHintTimer;

  static const List<String> _searchHints = [
    'Busca "Palta Fuerte Hass"...',
    'Busca "Lomo Saltado Clásico"...',
    'Busca "Inca Kola 1.5L"...',
    'Busca "Pan Francés Artesanal"...',
    'Busca "Leche Gloria Azul"...',
  ];

  @override
  void initState() {
    super.initState();
    _startHintRotation();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _startHintRotation() {
    _searchHintTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _searchHintIndex = (_searchHintIndex + 1) % _searchHints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchHintTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    final vouchersFuture =
        ref.read(vouchersProvider.notifier).fetchVouchers();
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (mounted) {
        setState(() => _currentLocation = position);
        ref.read(restaurantProvider.notifier).fetchNearbyRestaurants(
              latitude: position.latitude,
              longitude: position.longitude,
            );
      }
    } catch (_) {
      if (mounted) {
        ref.read(restaurantProvider.notifier).fetchNearbyRestaurants();
      }
    }
    await vouchersFuture;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final restaurantState = ref.watch(restaurantProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: _loadData,
              color: AppColors.primary,
              child: CustomScrollView(
                slivers: [
                  // Top Header: Delivery ETA Badge + Location + Profile
                  SliverToBoxAdapter(
                    child: _buildHeader(authState.user?.fullName ?? ''),
                  ),

                  // Blinkit-style Sticky Animated Search Trigger
                  SliverToBoxAdapter(
                    child: _buildSearchBar(),
                  ),

                  // Peruvian Market Category Grid
                  SliverToBoxAdapter(
                    child: _buildCategoryGrid(),
                  ),

                  // Flash Deals (Ofertas Relámpago)
                  SliverToBoxAdapter(
                    child: _buildFlashDealsSection(),
                  ),

                  // Promotional Banner
                  SliverToBoxAdapter(
                    child: _buildPromoBanner(),
                  ),

                  // Featured Peruvian Quick-Commerce Products
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      title: 'Favoritos de Lima • Al toque',
                      subtitle: 'Llegan a tu puerta en 15 minutos',
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = PeruSeedData.allProducts[index %
                              PeruSeedData.allProducts.length];
                          return PlazaProductCard(
                            item: product,
                            discountTag: index == 1 ? 'MÁS PEDIDO' : null,
                          );
                        },
                        childCount: 6,
                      ),
                    ),
                  ),

                  // Nearby restaurants / Hot food kitchens from live backend
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      title: l10n.nearbyRestaurants,
                      subtitle: 'Restaurantes y cocinas aliadas',
                      actionText: l10n.viewAll,
                      onActionTap: () => context.push(Routes.restaurants),
                    ),
                  ),

                  if (restaurantState.isLoading)
                    const SliverToBoxAdapter(
                      child: PeruvianQuickCommerceShimmer(count: 2),
                    )
                  else if (restaurantState.error != null)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ErrorState(
                          message: localizeAppError(
                            l10n,
                            restaurantState.error!,
                          ),
                          onRetry: _loadData,
                        ),
                      ),
                    )
                  else if (restaurantState.nearbyRestaurants.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final restaurant =
                              restaurantState.nearbyRestaurants[index];
                          return RestaurantCard(
                            restaurant: restaurant,
                            onTap: () => context.push(
                              Routes.restaurantDetail,
                              extra: restaurant.id,
                            ),
                          );
                        },
                        childCount: restaurantState.nearbyRestaurants.length,
                      ),
                    ),

                  // Extra bottom clearance for Floating Cart Bar and Bottom Nav
                  const SliverToBoxAdapter(child: SizedBox(height: 110)),
                ],
              ),
            ),

            // Persistent Floating Cart Bar
            const Positioned(
              left: 0,
              right: 0,
              bottom: 60,
              child: FloatingCartBar(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader(String userName) {
    final l10n = AppLocalizations.of(context);
    final locationLabel = customerHomeLocationLabel(
      l10n,
      hasLocation: _currentLocation != null,
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Delivery ETA Badge (Blinkit 15 min pattern)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00966B), Color(0xFF007A55)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00966B).withValues(alpha: 0.28),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded, size: 16, color: Color(0xFFFFD54F)),
                SizedBox(width: 3),
                Text(
                  '15 MIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Location details (tested via customerHomeLocationLabel)
          Expanded(
            child: InkWell(
              onTap: () => context.push(Routes.addresses),
              borderRadius: BorderRadius.circular(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Entrega en',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF757575),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _currentLocation != null
                            ? 'Miraflores'
                            : 'Plaza 4 Express',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF00966B),
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: Color(0xFF00966B),
                      ),
                    ],
                  ),
                  Text(
                    _currentLocation != null
                        ? locationLabel
                        : PeruSeedData.defaultLocation,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E2229),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Profile avatar
          GestureDetector(
            onTap: () => context.push(Routes.profile),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFF424242),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: GestureDetector(
        onTap: () => context.push(Routes.search),
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search_rounded,
                color: Color(0xFF00966B),
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.4),
                        end: Offset.zero,
                      ).animate(animation),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Align(
                    key: ValueKey<int>(_searchHintIndex),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _searchHints[_searchHintIndex],
                      style: const TextStyle(
                        fontSize: 13.5,
                        color: Color(0xFF888888),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              Container(
                height: 20,
                width: 1,
                color: const Color(0xFFD1D5DB),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.mic_none_rounded,
                color: Color(0xFF757575),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pasillos de Plaza 4',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2229),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryBrowseScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Ver pasillos →',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00966B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: PeruSeedData.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, index) {
              final cat = PeruSeedData.categories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CategoryBrowseScreen(
                        initialCategoryId: cat.id,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: cat.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: cat.color.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(cat.icon, color: cat.color, size: 26),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      cat.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50),
                        height: 1.15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFlashDealsSection() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.timer_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'RELÁMPAGO',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Ofertas del Día',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E2229),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Termina en 02:45:10',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE65100),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 232,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              scrollDirection: Axis.horizontal,
              itemCount: PeruSeedData.flashDeals.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final deal = PeruSeedData.flashDeals[index];
                return PlazaProductCard(
                  item: deal.product,
                  originalPrice: deal.originalPrice,
                  discountTag: '-${deal.discountPercent}%',
                  width: 150,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
      child: PromoBanner(
        title: '¡Pide con Yape o Plin!',
        subtitle: 'Envío express S/ 6.00 en toda tu compra',
        color: const Color(0xFF742284), // Yape purple
        onTap: () => context.push(Routes.vouchers),
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? subtitle,
    String? actionText,
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2229),
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          if (actionText != null)
            TextButton(
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionText,
                style: const TextStyle(
                  color: Color(0xFF00966B),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.storefront_rounded,
                label: 'Inicio',
                isSelected: true,
                onTap: () {},
              ),
              _navItem(
                icon: Icons.grid_view_rounded,
                label: 'Pasillos',
                isSelected: false,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryBrowseScreen(),
                    ),
                  );
                },
              ),
              _navItem(
                icon: Icons.search_rounded,
                label: 'Buscar',
                isSelected: false,
                onTap: () => context.push(Routes.search),
              ),
              _navItem(
                icon: Icons.receipt_long_rounded,
                label: 'Pedidos',
                isSelected: false,
                onTap: () => context.push(Routes.orders),
              ),
              _navItem(
                icon: Icons.person_outline_rounded,
                label: 'Perfil',
                isSelected: false,
                onTap: () => context.push(Routes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isSelected ? const Color(0xFF00966B) : const Color(0xFF9E9E9E),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
              color:
                  isSelected ? const Color(0xFF00966B) : const Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}
