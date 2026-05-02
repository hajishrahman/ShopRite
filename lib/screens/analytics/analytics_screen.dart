import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/analytics_provider.dart';
import '../../providers/cart_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final analytics = context.watch<AnalyticsProvider>();
    analytics.update(cart);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Shopping Insights', style: AppTypography.headingSmall),
      ),
      body: analytics.totalItems == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bar_chart, size: 80, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('No data yet', style: AppTypography.headingSmall),
                  Text('Add products to your cart to see insights', style: AppTypography.bodyMedium),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryCards(analytics: analytics),
                  const SizedBox(height: 24),
                  if (analytics.topCategories.isNotEmpty) ...[
                    Text('Spending by Category', style: AppTypography.headingSmall),
                    const SizedBox(height: 8),
                    Text('Insight: See which categories you spend the most on',
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    _CategoryBarChart(analytics: analytics),
                    const SizedBox(height: 24),
                  ],
                  Text('Cart Breakdown', style: AppTypography.headingSmall),
                  const SizedBox(height: 16),
                  _CartBreakdown(cart: cart),
                ],
              ),
            ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final AnalyticsProvider analytics;
  const _SummaryCards({required this.analytics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _StatCard(
          title: 'Cart Value',
          value: '${AppConstants.currency}${analytics.totalSpending.toStringAsFixed(0)}',
          icon: Icons.shopping_cart,
          color: AppColors.primary,
        ),
        _StatCard(
          title: 'Total Savings',
          value: '${AppConstants.currency}${analytics.totalSavings.toStringAsFixed(0)}',
          icon: Icons.savings,
          color: AppColors.accent,
        ),
        _StatCard(
          title: 'Total Items',
          value: '${analytics.totalItems}',
          icon: Icons.inventory_2,
          color: AppColors.secondary,
        ),
        _StatCard(
          title: 'Tax (GST)',
          value: '${AppConstants.currency}${analytics.totalTax.toStringAsFixed(0)}',
          icon: Icons.receipt,
          color: AppColors.warning,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTypography.headingSmall.copyWith(color: color)),
              Text(title, style: AppTypography.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryBarChart extends StatelessWidget {
  final AnalyticsProvider analytics;
  const _CategoryBarChart({required this.analytics});

  @override
  Widget build(BuildContext context) {
    final categories = analytics.topCategories;
    final maxValue = categories.isEmpty ? 1.0 : categories.first.value;

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
      ),
      child: BarChart(
        BarChartData(
          maxY: maxValue * 1.2,
          barGroups: categories.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value,
                  color: AppColors.primary,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= categories.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      categories[value.toInt()].key.substring(0, categories[value.toInt()].key.length > 5 ? 5 : categories[value.toInt()].key.length),
                      style: AppTypography.bodySmall,
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

class _CartBreakdown extends StatelessWidget {
  final CartProvider cart;
  const _CartBreakdown({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 4)],
      ),
      child: Column(
        children: cart.cartItems.map((item) {
          final percent = cart.subtotal > 0 ? (item.totalPrice / cart.subtotal) : 0.0;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(item.product.name, style: AppTypography.bodyMedium, overflow: TextOverflow.ellipsis)),
                    Text('${AppConstants.currency}${item.totalPrice.toStringAsFixed(0)}', style: AppTypography.bodyMedium),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percent.toDouble(),
                  backgroundColor: AppColors.background,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 2),
                Text('${(percent * 100).toStringAsFixed(1)}% of cart value',
                  style: AppTypography.bodySmall),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}