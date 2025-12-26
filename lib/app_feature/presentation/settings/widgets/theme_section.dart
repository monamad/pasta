import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';
import 'package:pasta/core/theme/theme_cubit.dart';

class ThemeSection extends StatelessWidget {
  const ThemeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance', style: AppTextStyles.bold16),
            SizedBox(height: 16.h),
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          themeMode == ThemeMode.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          themeMode == ThemeMode.dark
                              ? 'Dark Mode'
                              : 'Light Mode',
                          style: AppTextStyles.medium14,
                        ),
                      ],
                    ),
                    Switch(
                      value: themeMode == ThemeMode.dark,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().toggleTheme(),
                      activeThumbColor: AppColors.primary,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
