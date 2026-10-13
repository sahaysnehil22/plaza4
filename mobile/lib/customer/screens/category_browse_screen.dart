import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/models/menu_item.dart';
import '../../shared/theme/app_colors.dart';
import '../data/peru_seed_data.dart';
import '../router/route_names.dart';
import '../widgets/plaza_product_card.dart';
import '../widgets/floating_cart_bar.dart';
import '../widgets/peruvian_quick_commerce_shimmer.dart';

/// Blinkit-style dual-rail category browse screen.
///
/// Left Rail: Vertical navigation through Peruvian supermarket categories.
/// Right Panel: Subcategory chips + 2-column high-density product grid with
/// quick-add steppers and live cart synchronization.
class CategoryBrowseScreen extends ConsumerStatefulWidget {
  final String? initialCategoryId;

  const CategoryBrowseScreen({super.key, this.initialCategoryId});

  @override
  ConsumerState<CategoryBrowseScreen> createState() =>
      _CategoryBrowseScreenState();
}

class _CategoryBrowseScreenState extends ConsumerState<CategoryBrowseScreen> {
  late String _selectedCategoryId;
  String? _selectedSubFilter;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId =
        widget.initialCategoryId ?? PeruSeedData.categories.first.id;
  }

  List<MenuItemModel> get _filteredProducts {
    final list = PeruSeedData.allProducts
        .where((p) => p.category == _selectedCategoryId)
        .toList();

    if (list.isEmpty) {
      // Fallback: show popular items if category has fewer seeded products
      return PeruSeedData.allProducts.take(6).toList();
    }
    return list;
  }

  Future<void> _refreshCategory() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 350));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final currentCat = PeruSeedData.categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => PeruSeedData.categories.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E2229)),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  currentCat.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E2229),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '15 min',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF007A55),
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'Plaza 4 Express • Pasaje fresco',
              style: TextStyle(fontSize: 11, color: Color(0xFF757575)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Color(0xFF1E2229)),
            onPressed: () => context.push(Routes.search),
          ),
        ],
      ),
      body: Stack(
        children: [
          Row(
            children: [
              // Left Vertical Navigation Rail
              _buildLeftRail(),

              // Right Product Area
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshCategory,
                  color: AppColors.primary,
                  child: _isLoading
                      ? const PeruvianQuickCommerceShimmer(count: 6)
                      : _buildProductsArea(),
                ),
              ),
            ],
          ),

          // Persistent Floating Cart Bar at bottom
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingCartBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftRail() {
    return Container(
      width: 78,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFEEEEEE), width: 1),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: PeruSeedData.categories.length,
        itemBuilder: (context, index) {
          final cat = PeruSeedData.categories[index];
          final isSelected = cat.id == _selectedCategoryId;

          return InkWell(
            onTap: () {
              setState(() {
                _selectedCategoryId = cat.id;
                _selectedSubFilter = null;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE8F5E9).withValues(alpha: 0.6)
                    : Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: isSelected
                        ? const Color(0xFF00966B)
                        : Colors.transparent,
                    width: 3.5,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF00966B)
                          : const Color(0xFFF5F6F8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      cat.icon,
                      size: 22,
                      color: isSelected ? Colors.white : const Color(0xFF555555),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    cat.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF007A55)
                          : const Color(0xFF616161),
                      height: 1.15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsArea() {
    final products = _filteredProducts;

    return CustomScrollView(
      slivers: [
        // Subcategory filter chips
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _subChip('Todos', isSelected: _selectedSubFilter == null, onTap: () {
                    setState(() => _selectedSubFilter = null);
                  }),
                  const SizedBox(width: 6),
                  _subChip('Ofertas', isSelected: _selectedSubFilter == 'ofertas', onTap: () {
                    setState(() => _selectedSubFilter = 'ofertas');
                  }),
                  const SizedBox(width: 6),
                  _subChip('Más pedidos', isSelected: _selectedSubFilter == 'populares', onTap: () {
                    setState(() => _selectedSubFilter = 'populares');
                  }),
                ],
              ),
            ),
          ),
        ),

        // Product Grid
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 88),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.65,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index % products.length];
                return PlazaProductCard(
                  item: product,
                  discountTag: index == 0 ? 'OFERTA' : null,
                  originalPrice: index == 0 ? product.price * 1.2 : null,
                );
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _subChip(String label, {required bool isSelected, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00966B) : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF424242),
          ),
        ),
      ),
    );
  }
}
