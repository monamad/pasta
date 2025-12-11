import 'package:flutter/material.dart';
import 'package:pasta/app_feature/presentation/home/widgets/count_timer.dart';
import 'package:pasta/app_feature/presentation/home/widgets/custom_button.dart';
import 'package:pasta/app_feature/presentation/home/widgets/decorated_category_icon.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';

class SessionCard extends StatelessWidget {
  final int sessionId;
  final String title;
  final DateTime startTime;
  final DateTime? expectedEndTime;

  final String category;
  final String status;
  final String price;
  final VoidCallback onStop;
  final VoidCallback onExtend;

  const SessionCard({
    super.key,

    required this.sessionId,
    required this.title,
    required this.startTime,
    required this.expectedEndTime,
    required this.category,
    required this.status,
    required this.price,
    required this.onStop,
    required this.onExtend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                DecoratedCategoryIcon(data: categoryIcons[category]!),
                SizedBox(width: 10),
                Text(title, style: AppTextStyles.bold16),
                Spacer(),
                Column(
                  children: [
                    startTime.isBefore(DateTime.now())
                        ? CountTimer(
                            key: ValueKey(expectedEndTime),
                            expectedEndTime: expectedEndTime,
                            sessionId: sessionId,
                            startedAt: startTime,
                          )
                        : Text(
                            'Starts at ${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}',
                            style: AppTextStyles.bold14,
                          ),
                    SizedBox(height: 4),
                    Text(
                      expectedEndTime != null ? 'Duration' : 'Open Session',
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.grayDeep,
                      ),
                    ),
                    if (expectedEndTime != null &&
                        startTime.isAfter(DateTime.now())) ...[
                      SizedBox(height: 4),
                      //showing duration
                      Text(
                        '${expectedEndTime!.difference(startTime).inMinutes / 60} hrs',
                        style: AppTextStyles.regular12.copyWith(
                          color: AppColors.grayDeep,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  category,
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.grayDeep,
                  ),
                ),
                Spacer(),
                Text(
                  status,
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.grayDeep,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  price,
                  style: AppTextStyles.regular14.copyWith(
                    color: AppColors.grayDeep,
                  ),
                ),
                Spacer(),
                CustomButton(
                  text: 'Stop',
                  width: 80,
                  height: 30,
                  textStyle: AppTextStyles.semiBold14.copyWith(
                    color: AppColors.red,
                  ),
                  color: AppColors.pinkLight,
                  onTap: onStop,
                ),
                if (expectedEndTime != null) ...[
                  SizedBox(width: 10),
                  CustomButton(
                    text: 'Extend',
                    width: 80,
                    height: 30,
                    textStyle: AppTextStyles.semiBold14.copyWith(
                      color: AppColors.primary,
                    ),
                    color: AppColors.blueSoft,
                    onTap: onExtend,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
