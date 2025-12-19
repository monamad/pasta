import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24.sp),
                ),
                Spacer(),
                Text(
                  statusText,
                  style: AppTextStyles.regular16.copyWith(color: statusColor),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(value, style: AppTextStyles.bold24),
            SizedBox(height: 8.h),
            AutoSizeText(label, style: AppTextStyles.regular16, maxLines: 1),
          ],
        ),
      ),
    );
  }
}
