import 'package:flutter/material.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';


class DurationSelector extends StatelessWidget {
  final int duration;
  final ValueChanged<int> onDurationChanged;

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
        const Text(
          'Duration (Hours)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _CircleButton(
              icon: Icons.remove,
              onTap: duration > 1
                  ? () => onDurationChanged(duration - 1)
                  : null,
              theme: theme,
            ),
            const SizedBox(width: 32),
            Text(duration.toString(), style: AppTextStyles.bold20),
            const SizedBox(width: 32),
            _CircleButton(
              icon: Icons.add,
              onTap: () => onDurationChanged(duration + 1),
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
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.grayLight,

          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.grayDeep, size: 20),
      ),
    );
  }
}
