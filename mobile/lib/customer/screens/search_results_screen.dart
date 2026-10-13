import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/error_state.dart';
import '../../shared/widgets/loading_shimmer.dart';
import '../../shared/utils/currency_formatter.dart';
import '../../shared/utils/app_error_messages.dart';
import '../providers/search_provider.dart';
import '../widgets/search_filter_chips.dart';
import '../widgets/floating_cart_bar.dart';
import '../widgets/plaza_product_card.dart';
import '../data/peru_seed_data.dart';
import '../router/route_names.dart';

class SearchResultsScreen extends ConsumerStatefulWidget {
  final String initialQuery;
  const SearchResultsScreen({super.key, this.initialQuery = ''});

  @override
  ConsumerState<SearchResultsScreen> createState() =>
      _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  final _searchController = TextEditingController();
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery.isNotEmpty) {
      _searchController.text = widget.initialQuery;
      Future.microtask(() {
        ref.read(searchProvider.notifier).search(widget.initialQuery);
        setState(() => _hasSearched = true);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch([String? term]) {
    final query = (term ?? _searchController.text).trim();
    if (query.isEmpty) return;
    if (term != null) _searchController.text = term;
    setState(() => _hasSearched = true);
    ref.read(searchProvider.notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: SizedBox(
          height: 42,
          child: TextField(
            controller: _searchController,
            autofocus: widget.initialQuery.isEmpty,
            onSubmitted: (_) => _performSearch(),
            onChanged: (v) => ref.read(searchProvider.notifier).updateQuery(v),
            decoration: InputDecoration(
              hintText: 'Busca productos, abarrotes, platos...',
              hintStyle: const TextStyle(
                fontSize: 13,
                color: Color(0xFF9E9E9E),
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 20,
                color: Color(0xFF00966B),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(searchProvider.notifier).updateQuery('');
                        setState(() => _hasSearched = false);
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          TextButton(
            onPressed: _searchController.text.trim().isNotEmpty
                ? () => _performSearch()
                : null,
            child: Text(
              l10n.searchButtonLabel,
              style: TextStyle(
                color: _searchController.text.trim().isNotEmpty
                    ? const Color(0xFF00966B)
                    : AppColors.textHint,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildBody(state),
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

  Widget _buildBody(SearchState state) {
    final l10n = AppLocalizations.of(context);

    if (!_hasSearched) {
      return _buildRecentAndTrending(state);
    }
    if (state.isLoading) {
      return const LoadingShimmer(type: ShimmerType.restaurant, itemCount: 4);
    }
    if (state.error != null) {
      return ErrorState(
        message: localizeAppError(l10n, state.error!),
        onRetry: _performSearch,
      );
    }
    return Column(
      children: [
        // Filter chips
        SearchFilterChips(
          selectedSort: state.sort,
          onChanged: (sort) =>
              ref.read(searchProvider.notifier).updateSort(sort),
          labels: {
            SearchSort.nearest: l10n.searchFilterNearest,
            SearchSort.topRated: l10n.searchFilterTopRated,
            SearchSort.priceLowHigh: l10n.searchFilterPriceLowHigh,
            SearchSort.openNow: l10n.searchFilterOpenNow,
          },
        ),
        // Results
        Expanded(child: _buildResults(state)),
      ],
    );
  }

  Widget _buildRecentAndTrending(SearchState state) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Trending in Peru
        Row(
          children: [
            const Icon(
              Icons.trending_up_rounded,
              color: Color(0xFF00966B),
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Búsquedas populares en Perú',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E2229),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: PeruSeedData.trendingSearchesPeru.map((term) {
            return InkWell(
              onTap: () => _performSearch(term),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 14,
                      color: Color(0xFF757575),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      term,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF424242),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 24),

        // Recent searches if any
        if (state.recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.searchRecentLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2229),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    ref.read(searchProvider.notifier).clearRecentSearches(),
                child: Text(
                  l10n.searchClearAll,
                  style: const TextStyle(
                    color: Color(0xFFE53935),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...state.recentSearches.map(
            (term) => ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: const Icon(
                Icons.history_rounded,
                size: 18,
                color: Color(0xFF9E9E9E),
              ),
              title: Text(
                term,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF424242),
                ),
              ),
              trailing: const Icon(
                Icons.north_west_rounded,
                size: 16,
                color: Color(0xFFBDBDBD),
              ),
              onTap: () => _performSearch(term),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResults(SearchState state) {
    final l10n = AppLocalizations.of(context);
    final query = _searchController.text.toLowerCase();

    // Check seed products matching query for instant offline richness
    final matchingSeedProducts = PeruSeedData.allProducts
        .where((p) =>
            p.name.toLowerCase().contains(query) ||
            (p.description?.toLowerCase().contains(query) ?? false) ||
            p.category.toLowerCase().contains(query))
        .toList();

    if (state.results.isEmpty && matchingSeedProducts.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: l10n.searchNoResults(state.query),
        subtitle: l10n.searchNoResultsSubtitle,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => _performSearch(),
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          // If we have matching seed items, show high-density cards
          if (matchingSeedProducts.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Productos en Plaza 4 Express (${matchingSeedProducts.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2229),
                ),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemCount: matchingSeedProducts.length,
              itemBuilder: (context, i) {
                return PlazaProductCard(item: matchingSeedProducts[i]);
              },
            ),
            const SizedBox(height: 16),
          ],

          // Backend API search results
          if (state.results.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Restaurantes y comercios asociados',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2229),
                ),
              ),
            ),
            ...state.results.map((r) => _buildResultCard(r)),
          ],
        ],
      ),
    );
  }

  Widget _buildResultCard(SearchResultItem item) {
    return GestureDetector(
      onTap: () {
        if (item.type == 'restaurant') {
          context.push(Routes.restaurantDetail, extra: item.id);
        } else {
          context.push(
            Routes.foodDetail,
            extra: {'item': item, 'restaurantName': item.subtitle ?? ''},
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: item.imageUrl.isNotEmpty
                  ? Image.network(
                      item.imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E2229),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (item.rating != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFFFA000),
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          item.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (item.distanceKm != null)
                          Text(
                            '• ${item.distanceKm!.toStringAsFixed(1)} km',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                            ),
                          ),
                      ],
                    ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (item.price != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      formatPen(context, item.price!),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF00966B),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (!item.isOpen)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppLocalizations.of(context).searchClosedBadge,
                  style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 72,
      height: 72,
      color: const Color(0xFFF3F4F6),
      child: const Icon(
        Icons.storefront_rounded,
        color: Color(0xFFBDC3C7),
      ),
    );
  }
}
