import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../services/seed_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();
  final SeedService _seedService = SeedService();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<ProductModel> _featuredProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  double _minPrice = 0;
  double _maxPrice = 200000;
  double _minRating = 0;
  bool _onSaleOnly = false;

  List<ProductModel> get allProducts => _allProducts;
  List<ProductModel> get filteredProducts => _filteredProducts;
  List<ProductModel> get featuredProducts => _featuredProducts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double get minRating => _minRating;
  bool get onSaleOnly => _onSaleOnly;

  List<String> get categories {
    final cats = _allProducts.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    await _seedService.seedProducts();
    _allProducts = await _productService.getAllProducts();
    _featuredProducts = _allProducts.where((p) => p.isFeatured).toList();
    _applyFilters();
    _isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void setMinRating(double rating) {
    _minRating = rating;
    _applyFilters();
  }

  void setOnSaleOnly(bool value) {
    _onSaleOnly = value;
    _applyFilters();
  }

  void resetFilters() {
    _selectedCategory = 'All';
    _minPrice = 0;
    _maxPrice = 200000;
    _minRating = 0;
    _onSaleOnly = false;
    _searchQuery = '';
    _applyFilters();
  }

  void _applyFilters() {
    List<ProductModel> result = _allProducts;
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((p) =>
        p.name.toLowerCase().contains(q) ||
        p.category.toLowerCase().contains(q) ||
        p.description.toLowerCase().contains(q)
      ).toList();
    }
    result = _productService.filterProducts(
      result,
      category: _selectedCategory,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      minRating: _minRating == 0 ? null : _minRating,
      onSaleOnly: _onSaleOnly,
    );
    _filteredProducts = result;
    notifyListeners();
  }
}
