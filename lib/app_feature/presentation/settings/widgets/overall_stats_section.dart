import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/data/models/statistics_models.dart';
import 'package:pasta/core/theme/app_style.dart';

class OverallStatsSection extends StatelessWidget {
  final OverallStats stats;

  const OverallStatsSection({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
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
}
