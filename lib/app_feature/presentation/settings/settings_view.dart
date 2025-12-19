import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/data/models/statistics_models.dart';
import 'package:pasta/app_feature/logic/settings/settings_cubit.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';
import 'package:pasta/core/theme/theme_cubit.dart';

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
                  _buildThemeSection(context),
                  SizedBox(height: 24.h),
                  if (state.overallStats != null) ...[
                    _buildOverallStatsSection(state.overallStats!),
                    SizedBox(height: 24.h),
                  ],
                  if (state.last7DaysRevenue.isNotEmpty) ...[
                    _buildRevenueChart(context, state.last7DaysRevenue),
                    SizedBox(height: 24.h),
                  ],
                  if (state.categoryStats.isNotEmpty) ...[
                    _buildCategoryPieChart(context, state.categoryStats),
                    SizedBox(height: 24.h),
                  ],
                  if (state.hourlyDistribution.isNotEmpty) ...[
                    _buildHourlyChart(context, state.hourlyDistribution),
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

  Widget _buildThemeSection(BuildContext context) {
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

  Widget _buildOverallStatsSection(OverallStats stats) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Overview', style: AppTextStyles.bold16),
            SizedBox(height: 16.h),
            _buildStatsRow(
              'Today\'s Revenue',
              '\$${stats.todayRevenue.toStringAsFixed(2)}',
            ),
            _buildStatsRow(
              'Week\'s Revenue',
              '\$${stats.weekRevenue.toStringAsFixed(2)}',
            ),
            _buildStatsRow(
              'Month\'s Revenue',
              '\$${stats.monthRevenue.toStringAsFixed(2)}',
            ),
            Divider(height: 24.h),
            _buildStatsRow('Today\'s Sessions', '${stats.todaySessions}'),
            _buildStatsRow('Week\'s Sessions', '${stats.weekSessions}'),
            _buildStatsRow('Month\'s Sessions', '${stats.monthSessions}'),
            Divider(height: 24.h),
            _buildStatsRow(
              'Avg Session Duration',
              '${stats.averageSessionDuration.toStringAsFixed(0)} min',
            ),
            _buildStatsRow('Most Popular', stats.mostPopularCategory),
            _buildStatsRow('Busiest Hour', stats.busiestHour),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.regular16),
          Text(value, style: AppTextStyles.bold14),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context, List<DailyRevenue> data) {
    final maxRevenue = data
        .map((e) => e.revenue)
        .reduce((a, b) => a > b ? a : b);
    final interval = maxRevenue > 0 ? (maxRevenue / 4).ceilToDouble() : 50.0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last 7 Days Revenue', style: AppTextStyles.bold16),
            SizedBox(height: 24.h),
            SizedBox(
              height: 200.h,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxRevenue > 0 ? maxRevenue * 1.2 : 100,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final day = data[group.x.toInt()];
                        return BarTooltipItem(
                          '\$${day.revenue.toStringAsFixed(2)}\n${day.sessionCount} sessions',
                          TextStyle(color: Colors.white, fontSize: 12.sp),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < data.length) {
                            final day = data[index].date;
                            return Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                _getDayName(day.weekday),
                                style: AppTextStyles.regular10,
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: interval > 0 ? interval : 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '\$${value.toInt()}',
                            style: AppTextStyles.regular10,
                          );
                        },
                        reservedSize: 45,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: interval > 0 ? interval : 50,
                  ),
                  barGroups: data.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.revenue,
                          color: AppColors.primary,
                          width: 20,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            topRight: Radius.circular(4.r),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart(
    BuildContext context,
    List<CategoryStats> data,
  ) {
    final colors = [
      AppColors.primary,
      AppColors.green,
      AppColors.orange,
      AppColors.red,
      AppColors.purple,
      AppColors.teal,
    ];

    final totalSessions = data.fold<int>(0, (sum, e) => sum + e.sessionCount);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sessions by Category (This Month)',
              style: AppTextStyles.bold16,
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40.r,
                        sections: data.asMap().entries.map((entry) {
                          final percentage = totalSessions > 0
                              ? (entry.value.sessionCount / totalSessions * 100)
                              : 0.0;
                          return PieChartSectionData(
                            color: colors[entry.key % colors.length],
                            value: entry.value.sessionCount.toDouble(),
                            title: percentage > 5
                                ? '${percentage.toStringAsFixed(0)}%'
                                : '',
                            radius: 50.r,
                            titleStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data.asMap().entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: colors[entry.key % colors.length],
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${entry.value.categoryName} (${entry.value.sessionCount})',
                              style: AppTextStyles.regular14,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            ...data.map(
              (cat) => Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cat.categoryName, style: AppTextStyles.medium14),
                    Text(
                      '\$${cat.totalRevenue.toStringAsFixed(2)} • ${cat.totalHours.toStringAsFixed(1)}h',
                      style: AppTextStyles.regular14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyChart(
    BuildContext context,
    List<HourlyDistribution> data,
  ) {
    final filteredData = data
        .where((d) => d.hour >= 5 && d.hour <= 24)
        .toList();

    filteredData.sort((a, b) => a.hour.compareTo(b.hour));

    final completeData = <HourlyDistribution>[];
    for (int hour = 5; hour <= 24; hour++) {
      final existingData = filteredData.firstWhere(
        (d) => d.hour == hour,
        orElse: () => HourlyDistribution(hour: hour, sessionCount: 0),
      );
      completeData.add(existingData);
    }

    final maxCount = completeData.isNotEmpty
        ? completeData
              .map((e) => e.sessionCount)
              .reduce((a, b) => a > b ? a : b)
        : 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Busiest Hours (This Month)', style: AppTextStyles.bold16),
            SizedBox(height: 24.h),
            SizedBox(
              height: 200.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxCount > 5 ? (maxCount / 5) : 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withValues(alpha: 0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2,
                        getTitlesWidget: (value, meta) {
                          final hour = value.toInt();

                          if (hour >= 5 && hour <= 24) {
                            if (hour == 5 || hour == 24 || hour % 4 == 0) {
                              return Padding(
                                padding: EdgeInsets.only(top: 8.h),
                                child: Text(
                                  '${hour.toString()}:00',
                                  style: AppTextStyles.regular10,
                                ),
                              );
                            }
                          }
                          return const SizedBox();
                        },
                        reservedSize: 32,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: maxCount > 5
                            ? (maxCount / 5).ceilToDouble()
                            : 1,
                        getTitlesWidget: (value, meta) {
                          if (value == meta.max || value == meta.min) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: Text(
                              value.toInt().toString(),
                              style: AppTextStyles.regular10,
                            ),
                          );
                        },
                        reservedSize: 32,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      left: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  minX: 5,
                  maxX: 24,
                  minY: 0,
                  maxY: maxCount > 0 ? (maxCount * 1.2).ceilToDouble() : 10,
                  lineBarsData: [
                    LineChartBarData(
                      spots: completeData
                          .map(
                            (e) => FlSpot(
                              e.hour.toDouble(),
                              e.sessionCount.toDouble(),
                            ),
                          )
                          .toList(),
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: AppColors.blueDark.withValues(alpha: 0.8),
                      barWidth: 3.w,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.blueDark.withValues(alpha: 0.8),
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.blueDark.withValues(alpha: 0.3),
                            AppColors.blueDark.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.x.toInt()}:00\n${spot.y.toInt()} جلسة',
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
