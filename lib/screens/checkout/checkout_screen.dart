import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_textfield.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedPayment = 'UPI';
  bool _isProcessing = false;

  final List<String> _paymentMethods = ['UPI', 'Credit Card', 'Debit Card', 'Cash on Delivery'];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final cart = context.read<CartProvider>();
    cart.clearCart();
    setState(() => _isProcessing = false);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.accent, size: 72),
            const SizedBox(height: 16),
            Text('Order Placed!', style: AppTypography.headingMedium),
            const SizedBox(height: 8),
            Text('Your order has been placed successfully. You will receive a confirmation shortly.',
              style: AppTypography.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Continue Shopping',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Checkout', style: AppTypography.headingSmall),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Delivery Address', style: AppTypography.headingSmall),
              const SizedBox(height: 16),
              CustomTextField(
                hint: 'Full Name',
                controller: _nameController,
                prefixIcon: Icons.person_outlined,
                validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hint: 'Address',
                controller: _addressController,
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => v == null || v.isEmpty ? 'Enter your address' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hint: 'City',
                controller: _cityController,
                prefixIcon: Icons.location_city_outlined,
                validator: (v) => v == null || v.isEmpty ? 'Enter your city' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hint: 'Phone Number',
                controller: _phoneController,
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.length < 10 ? 'Enter valid phone number' : null,
              ),
              const SizedBox(height: 24),
              Text('Payment Method', style: AppTypography.headingSmall),
              const SizedBox(height: 12),
              ...(_paymentMethods.map((method) => RadioListTile<String>(
                title: Text(method, style: AppTypography.bodyLarge),
                value: method,
                groupValue: _selectedPayment,
                activeColor: AppColors.primary,
                onChanged: (value) => setState(() => _selectedPayment = value!),
              ))),
              const SizedBox(height: 24),
              Text('Order Summary', style: AppTypography.headingSmall),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    ...cart.cartItems.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: Text('${item.product.name} x${item.quantity}',
                            style: AppTypography.bodyMedium, overflow: TextOverflow.ellipsis)),
                          Text('${AppConstants.currency}${item.totalPrice.toStringAsFixed(0)}',
                            style: AppTypography.bodyMedium),
                        ],
                      ),
                    )),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal', style: AppTypography.bodyMedium),
                        Text('${AppConstants.currency}${cart.subtotal.toStringAsFixed(0)}', style: AppTypography.bodyMedium),
                      ],
                    ),
                    if (cart.bulkDiscount > 0) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Bulk Discount', style: AppTypography.bodyMedium.copyWith(color: AppColors.accent)),
                          Text('-${AppConstants.currency}${cart.bulkDiscount.toStringAsFixed(0)}',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.accent)),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Shipping', style: AppTypography.bodyMedium),
                        Text(cart.shippingCost == 0 ? 'FREE' : '${AppConstants.currency}${cart.shippingCost.toStringAsFixed(0)}',
                          style: AppTypography.bodyMedium.copyWith(
                            color: cart.shippingCost == 0 ? AppColors.accent : null)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tax (18%)', style: AppTypography.bodyMedium),
                        Text('${AppConstants.currency}${cart.tax.toStringAsFixed(0)}', style: AppTypography.bodyMedium),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                        Text('${AppConstants.currency}${cart.total.toStringAsFixed(0)}',
                          style: AppTypography.priceText),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                label: _isProcessing ? 'Processing...' : 'Place Order',
                onPressed: _placeOrder,
                isLoading: _isProcessing,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}