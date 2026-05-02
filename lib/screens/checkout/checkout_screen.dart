import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout', style: AppTypography.headingSmall),
      ),
      body: const Center(
        child: Text('Checkout - Coming Soon'),
      ),
    );
  }
}
