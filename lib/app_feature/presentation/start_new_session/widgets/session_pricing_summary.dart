import 'package:flutter/material.dart';

class SessionPricingSummary extends StatelessWidget {
  final double ratePerHour;
  final double estimatedTotal;

  const SessionPricingSummary({
    super.key,
    required this.ratePerHour,
    required this.estimatedTotal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _PricingRow(
          label: 'Rate per hour:',
          amount: ratePerHour,
          isTotal: false,
          theme: theme,
        ),
        const SizedBox(height: 8),
        _PricingRow(
          label: 'Estimated Total:',
          amount: estimatedTotal,
          isTotal: true,
          theme: theme,
        ),
      ],
    );
  }
}

class _PricingRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;
  final ThemeData theme;

  const _PricingRow({
    required this.label,
    required this.amount,
    required this.isTotal,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: isTotal
                ? theme.colorScheme.primary
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}
