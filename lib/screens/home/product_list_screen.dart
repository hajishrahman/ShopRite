import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/product_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/product/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => _FilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Products', style: AppTypography.headingSmall),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => context.read<ProductProvider>().search(value),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<ProductProvider>().search('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _showFilterSheet,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: products.categories.length,
              itemBuilder: (context, index) {
                final cat = products.categories[index];
                final isSelected = cat == products.selectedCategory;
                return GestureDetector(
                  onTap: () => context.read<ProductProvider>().setCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3)),
                    ),
                    child: Text(cat, style: AppTypography.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${products.filteredProducts.length} products', style: AppTypography.bodyMedium),
                TextButton(onPressed: () => context.read<ProductProvider>().resetFilters(), child: const Text('Reset')),
              ],
            ),
          ),
          Expanded(
            child: products.filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
                        const SizedBox(height: 16),
                        Text('No products found', style: AppTypography.headingSmall),
                        Text('Try a different search or filter', style: AppTypography.bodyMedium),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.58,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = products.filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onTap: () {},
                        onAddToCart: () => context
                            .read<CartProvider>()
                            .addToCart(product),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late double _minPrice;
  late double _maxPrice;
  late double _minRating;
  late bool _onSaleOnly;

  @override
  void initState() {
    super.initState();
    final p = context.read<ProductProvider>();
    _minPrice = p.minPrice;
    _maxPrice = p.maxPrice;
    _minRating = p.minRating;
    _onSaleOnly = p.onSaleOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter Products', style: AppTypography.headingSmall),
          const SizedBox(height: 24),
          Text('Price Range', style: AppTypography.bodyLarge),
          RangeSlider(
            min: 0,
            max: 200000,
            values: RangeValues(_minPrice, _maxPrice),
            activeColor: AppColors.primary,
            onChanged: (values) => setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('₹${_minPrice.toStringAsFixed(0)}', style: AppTypography.bodyMedium),
              Text('₹${_maxPrice.toStringAsFixed(0)}', style: AppTypography.bodyMedium),
            ],
          ),
          const SizedBox(height: 16),
          Text('Minimum Rating', style: AppTypography.bodyLarge),
          Slider(
            min: 0,
            max: 5,
            divisions: 10,
            value: _minRating,
            activeColor: AppColors.primary,
            label: _minRating == 0 ? 'Any' : '$_minRating★',
            onChanged: (value) => setState(() => _minRating = value),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('On Sale Only', style: AppTypography.bodyLarge),
              Switch(
                value: _onSaleOnly,
                activeThumbColor: AppColors.primary,
                onChanged: (value) => setState(() => _onSaleOnly = value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                final p = context.read<ProductProvider>();
                p.setPriceRange(_minPrice, _maxPrice);
                p.setMinRating(_minRating);
                p.setOnSaleOnly(_onSaleOnly);
                Navigator.pop(context);
              },
              child: Text('Apply Filters', style: AppTypography.buttonText),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
