import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/data/models/statistics_models.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';

class HourlyChart extends StatelessWidget {
  final List<HourlyDistribution> data;

  const HourlyChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
                            '${spot.x.toInt()}:00\n${spot.y.toInt()} sessions',
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
}
