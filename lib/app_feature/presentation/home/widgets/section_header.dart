import 'package:flutter/material.dart';
import 'package:pasta/core/theme/app_style.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback? onActionPressed;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText = 'View All',
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.bold18),
        GestureDetector(onTap: onActionPressed, child: Text(actionText)),
      ],
    );
  }
}
