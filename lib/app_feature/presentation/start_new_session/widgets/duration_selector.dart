import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';

class DurationSelector extends StatelessWidget {
  final double duration;
  final ValueChanged<double> onDurationChanged;

  const DurationSelector({
    super.key,
    required this.duration,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration (Hours)',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _CircleButton(
              icon: Icons.remove,
              onTap: duration > 0.5
                  ? () => onDurationChanged(duration - 0.5)
                  : null,
              theme: theme,
            ),
            SizedBox(width: 32.w),
            Text(duration.toString(), style: AppTextStyles.bold20),
            SizedBox(width: 32.w),
            _CircleButton(
              icon: Icons.add,
              onTap: () => onDurationChanged(duration + 0.5),
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final ThemeData theme;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: AppColors.grayLight,

          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.grayDeep, size: 20.sp),
      ),
    );
  }
}
