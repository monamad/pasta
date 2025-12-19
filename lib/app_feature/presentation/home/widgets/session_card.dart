import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/presentation/home/widgets/count_timer.dart';
import 'package:pasta/app_feature/presentation/home/widgets/custom_button.dart';
import 'package:pasta/app_feature/presentation/home/widgets/decorated_category_icon.dart';
import 'package:pasta/core/helper/functions.dart';
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
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                DecoratedCategoryIcon(data: categoryIcons[category]!),
                SizedBox(width: 10.w),
                Text(
                  title,
                  style: AppTextStyles.bold16.copyWith(
                    fontSize: MediaQuery.of(context).size.width > 400
                        ? 16
                        : 16.sp,
                  ),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    startTime.isBefore(DateTime.now())
                        ? CountTimer(
                            key: ValueKey(expectedEndTime),
                            expectedEndTime: expectedEndTime,
                            sessionId: sessionId,
                            startedAt: startTime,
                          )
                        : Text(
                            'Starts at ${formatTime12h(startTime)}',
                            style: AppTextStyles.bold14,
                          ),
                    SizedBox(height: 4.h),
                    AutoSizeText(
                      expectedEndTime != null ? 'Duration' : 'Open Session',
                      style: AppTextStyles.regular14.copyWith(
                        color: AppColors.grayDeep,
                      ),
                    ),

                    if (expectedEndTime != null &&
                        startTime.isAfter(DateTime.now())) ...[
                      SizedBox(height: 4.h),
                      //showing duration
                      Text(
                        '${expectedEndTime!.difference(startTime).inMinutes / 60} hrs',

                        style: AppTextStyles.regular16.copyWith(
                          color: AppColors.grayDeep,
                          fontSize: MediaQuery.of(context).size.width > 400
                              ? 16
                              : 16.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  category,
                  style: AppTextStyles.regular16.copyWith(
                    color: AppColors.grayDeep,
                  ),
                ),
                Spacer(),
                Text(
                  status,
                  style: AppTextStyles.regular16.copyWith(
                    color: AppColors.grayDeep,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  price,
                  style: AppTextStyles.regular16.copyWith(
                    color: AppColors.grayDeep,
                  ),
                ),
                Spacer(),
                CustomButton(
                  text: 'Stop',
                  width: 80.w,
                  height: 30.h,
                  textStyle: AppTextStyles.semiBold14.copyWith(
                    color: AppColors.red,
                  ),
                  color: AppColors.pinkLight,
                  onTap: onStop,
                ),
                if (expectedEndTime != null) ...[
                  SizedBox(width: 10.w),
                  CustomButton(
                    text: 'Extend',
                    width: 80.w,
                    height: 30.h,
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
