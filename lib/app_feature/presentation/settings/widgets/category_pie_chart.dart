import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/data/models/statistics_models.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';

class CategoryPieChart extends StatelessWidget {
  final List<CategoryStats> data;

  const CategoryPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
}
