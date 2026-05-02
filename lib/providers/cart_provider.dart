import 'package:flutter/material.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import '../core/constants/app_constants.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

  Map<String, CartItemModel> get items => _items;

  List<CartItemModel> get cartItems => _items.values.toList();

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0, (sum, item) => sum + item.totalPrice);

  // CUSTOM LOGIC: Bulk discount — if any item has quantity >= threshold, apply discount
  double get bulkDiscount {
    double discount = 0;
    for (final item in _items.values) {
      if (item.quantity >= AppConstants.bulkDiscountThreshold) {
        discount += item.totalPrice * (AppConstants.bulkDiscountPercent / 100);
      }
    }
    return discount;
  }

  // CUSTOM LOGIC: Free shipping if subtotal exceeds threshold
  double get shippingCost {
    if (subtotal >= AppConstants.freeShippingThreshold) return 0;
    return 49.0;
  }

  double get tax => subtotal * AppConstants.taxRate;

  double get total => subtotal - bulkDiscount + shippingCost + tax;

  double get totalSavings {
    double savings = 0;
    for (final item in _items.values) {
      if (item.product.isOnSale) {
        savings += item.originalTotalPrice - item.totalPrice;
      }
    }
    savings += bulkDiscount;
    return savings;
  }

  // CUSTOM LOGIC: Recommend products based on categories in cart
  List<String> get recommendedCategories {
    final categories = _items.values.map((e) => e.product.category).toSet();
    return categories.toList();
  }

  void addToCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItemModel(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.quantity--;
      } else {
        _items.remove(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) => _items.containsKey(productId);
}
