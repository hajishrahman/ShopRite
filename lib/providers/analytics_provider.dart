import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';

class AnalyticsProvider extends ChangeNotifier {
  CartProvider? _cartProvider;

  void update(CartProvider cartProvider) {
    _cartProvider = cartProvider;
    notifyListeners();
  }

  double get totalSpending => _cartProvider?.subtotal ?? 0;
  double get totalSavings => _cartProvider?.totalSavings ?? 0;
  double get totalTax => _cartProvider?.tax ?? 0;
  int get totalItems => _cartProvider?.itemCount ?? 0;

  Map<String, double> get spendingByCategory {
    if (_cartProvider == null) return {};
    final Map<String, double> result = {};
    for (final item in _cartProvider!.cartItems) {
      final cat = item.product.category;
      result[cat] = (result[cat] ?? 0) + item.totalPrice;
    }
    return result;
  }

  List<MapEntry<String, double>> get topCategories {
    final entries = spendingByCategory.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }
}
