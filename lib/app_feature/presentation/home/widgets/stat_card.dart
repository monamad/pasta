import 'package:flutter/material.dart';
import 'package:pasta/core/theme/app_style.dart';

class StatCard extends StatelessWidget {
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final String statusText;
  final Color statusColor;
  final String value;
  final String label;

  const StatCard({
    super.key,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.statusText,
    required this.statusColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white),
                ),
                Spacer(),
                Text(
                  statusText,
                  style: AppTextStyles.regular14.copyWith(color: statusColor),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(value, style: AppTextStyles.bold24),
            SizedBox(height: 8),
            Text(label, style: AppTextStyles.regular14),
          ],
        ),
      ),
    );
  }
}
