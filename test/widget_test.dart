import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shoprite/providers/cart_provider.dart';
import 'package:shoprite/providers/auth_provider.dart';
import 'package:shoprite/widgets/common/custom_button.dart';
import 'package:shoprite/widgets/common/custom_textfield.dart';
import 'package:shoprite/models/product_model.dart';
import 'package:shoprite/widgets/product/product_card.dart';

void main() {
  group('CustomButton Widget Tests', () {
    testWidgets('CustomButton displays label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('CustomButton shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Test Button',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test Button'), findsNothing);
    });

    testWidgets('CustomButton outlined variant renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(
              label: 'Outlined',
              onPressed: () {},
              isOutlined: true,
            ),
          ),
        ),
      );
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  });

  group('CustomTextField Widget Tests', () {
    testWidgets('CustomTextField displays hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomTextField(
              hint: 'Enter email',
              controller: TextEditingController(),
            ),
          ),
        ),
      );
      expect(find.text('Enter email'), findsOneWidget);
    });
  });

  group('CartProvider Unit Tests', () {
    late CartProvider cartProvider;
    late ProductModel testProduct;

    setUp(() {
      cartProvider = CartProvider();
      testProduct = ProductModel(
        id: 'test_001',
        name: 'Test Product',
        description: 'A test product',
        price: 1000,
        category: 'Electronics',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        isFeatured: false,
      );
    });

    test('Cart is empty initially', () {
      expect(cartProvider.cartItems.isEmpty, true);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.subtotal, 0);
    });

    test('Adding product increases item count', () {
      cartProvider.addToCart(testProduct);
      expect(cartProvider.itemCount, 1);
      expect(cartProvider.cartItems.length, 1);
    });

    test('Adding same product increments quantity', () {
      cartProvider.addToCart(testProduct);
      cartProvider.addToCart(testProduct);
      expect(cartProvider.itemCount, 2);
      expect(cartProvider.cartItems.length, 1);
    });

    test('Subtotal calculates correctly', () {
      cartProvider.addToCart(testProduct);
      cartProvider.addToCart(testProduct);
      expect(cartProvider.subtotal, 2000);
    });

    test('Bulk discount applied when quantity reaches threshold', () {
      cartProvider.addToCart(testProduct);
      cartProvider.addToCart(testProduct);
      cartProvider.addToCart(testProduct);
      expect(cartProvider.bulkDiscount, 300);
    });

    test('Remove from cart works correctly', () {
      cartProvider.addToCart(testProduct);
      cartProvider.removeFromCart(testProduct.id);
      expect(cartProvider.cartItems.isEmpty, true);
    });

    test('Clear cart empties all items', () {
      cartProvider.addToCart(testProduct);
      cartProvider.addToCart(testProduct);
      cartProvider.clearCart();
      expect(cartProvider.cartItems.isEmpty, true);
      expect(cartProvider.itemCount, 0);
    });

    test('Free shipping when subtotal exceeds threshold', () {
      final expensiveProduct = ProductModel(
        id: 'test_002',
        name: 'Expensive Product',
        description: 'An expensive product',
        price: 1000,
        category: 'Electronics',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.5,
        reviewCount: 10,
        stock: 20,
        isFeatured: false,
      );
      cartProvider.addToCart(expensiveProduct);
      expect(cartProvider.shippingCost, 0);
    });
  });

  group('ProductCard Widget Tests', () {
    late ProductModel testProduct;

    setUp(() {
      testProduct = ProductModel(
        id: 'test_001',
        name: 'iPhone 15',
        description: 'Latest iPhone',
        price: 79999,
        originalPrice: 89999,
        category: 'Electronics',
        imageUrl: 'https://example.com/image.jpg',
        rating: 4.8,
        reviewCount: 245,
        stock: 15,
        isFeatured: true,
      );
    });

    testWidgets('ProductCard displays product name', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => CartProvider()),
              ],
              child: ProductCard(
                product: testProduct,
                onTap: () {},
                onAddToCart: () {},
              ),
            ),
          ),
        ),
      );
      expect(find.text('iPhone 15'), findsOneWidget);
    });
  });
}
