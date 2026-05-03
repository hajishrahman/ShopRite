import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/custom_button.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Cart', style: AppTypography.headingSmall),
        actions: [
          if (cart.cartItems.isNotEmpty)
            TextButton(
              onPressed: () => cart.clearCart(),
              child: const Text('Clear All', style: TextStyle(color: AppColors.error)),
            ),
        ],
      ),
      body: cart.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: AppTypography.headingSmall),
                  Text('Add products to get started', style: AppTypography.bodyMedium),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cart.shippingCost == 0
                                ? '🎉 You got FREE Shipping!'
                                : 'Add Rs. ${(AppConstants.freeShippingThreshold - cart.subtotal).toStringAsFixed(0)} more for FREE Shipping',
                            style: AppTypography.bodySmall.copyWith(
                              color: cart.shippingCost == 0 ? AppColors.accent : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: (cart.subtotal / AppConstants.freeShippingThreshold).clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: AppColors.background,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            cart.shippingCost == 0 ? AppColors.accent : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 70,
                                  height: 70,
                                  color: AppColors.background,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('${AppConstants.currency}${item.product.price.toStringAsFixed(0)}', style: AppTypography.priceText.copyWith(fontSize: 16)),
                                  if (item.quantity >= AppConstants.bulkDiscountThreshold)
                                    Text('${AppConstants.bulkDiscountPercent.toInt()}% bulk discount applied!',
                                      style: AppTypography.bodySmall.copyWith(color: AppColors.accent)),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                  onPressed: () => cart.removeFromCart(item.product.id),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () => cart.decrementQuantity(item.product.id),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.textSecondary),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(Icons.remove, size: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Text('${item.quantity}', style: AppTypography.bodyLarge),
                                    ),
                                    GestureDetector(
                                      onTap: () => cart.incrementQuantity(item.product.id),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8)],
                  ),
                  child: Column(
                    children: [
                      _SummaryRow('Subtotal', '${AppConstants.currency}${cart.subtotal.toStringAsFixed(0)}'),
                      if (cart.bulkDiscount > 0)
                        _SummaryRow('Bulk Discount', '-${AppConstants.currency}${cart.bulkDiscount.toStringAsFixed(0)}', color: AppColors.accent),
                      _SummaryRow('Shipping', cart.shippingCost == 0 ? 'FREE' : '${AppConstants.currency}${cart.shippingCost.toStringAsFixed(0)}',
                        color: cart.shippingCost == 0 ? AppColors.accent : null),
                      _SummaryRow('Tax (18%)', '${AppConstants.currency}${cart.tax.toStringAsFixed(0)}'),
                      if (cart.totalSavings > 0)
                        _SummaryRow('Total Savings', '-${AppConstants.currency}${cart.totalSavings.toStringAsFixed(0)}', color: AppColors.accent),
                      const Divider(height: 24),
                      _SummaryRow('Total', '${AppConstants.currency}${cart.total.toStringAsFixed(0)}', isBold: true),
                      const SizedBox(height: 16),
                      CustomButton(
                        label: 'Proceed to Checkout',
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutScreen())),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isBold;

  const _SummaryRow(this.label, this.value, {this.color, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isBold ? AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold) : AppTypography.bodyMedium),
          Text(value, style: (isBold ? AppTypography.bodyLarge : AppTypography.bodyMedium).copyWith(
            color: color,
            fontWeight: isBold ? FontWeight.bold : null,
          )),
        ],
      ),
    );
  }
}
