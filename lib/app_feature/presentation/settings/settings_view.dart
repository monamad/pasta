import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/logic/settings/settings_cubit.dart';
import 'package:pasta/app_feature/presentation/settings/widgets/category_pie_chart.dart';
import 'package:pasta/app_feature/presentation/settings/widgets/hourly_chart.dart';
import 'package:pasta/app_feature/presentation/settings/widgets/overall_stats_section.dart';
import 'package:pasta/app_feature/presentation/settings/widgets/revenue_chart.dart';
import 'package:pasta/app_feature/presentation/settings/widgets/theme_section.dart';
import 'package:pasta/core/theme/app_style.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings & Statistics', style: AppTextStyles.bold18),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => context.read<SettingsCubit>().loadStatistics(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ThemeSection(),
                  SizedBox(height: 24.h),
                  if (state.overallStats != null) ...[
                    OverallStatsSection(stats: state.overallStats!),
                    SizedBox(height: 24.h),
                  ],
                  if (state.last7DaysRevenue.isNotEmpty) ...[
                    RevenueChart(data: state.last7DaysRevenue),
                    SizedBox(height: 24.h),
                  ],
                  if (state.categoryStats.isNotEmpty) ...[
                    CategoryPieChart(data: state.categoryStats),
                    SizedBox(height: 24.h),
                  ],
                  if (state.hourlyDistribution.isNotEmpty) ...[
                    HourlyChart(data: state.hourlyDistribution),
                    SizedBox(height: 24.h),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
