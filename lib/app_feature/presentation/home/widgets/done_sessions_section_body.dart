import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/decorated_category_icon.dart';
import 'package:pasta/core/helper/functions.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';

class DoneSessionsSectionBody extends StatelessWidget {
  const DoneSessionsSectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return Column(
            children: [
              if (state.doneSessions.isEmpty)
                Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Text(
                    'No done sessions',
                    style: AppTextStyles.regular16.copyWith(color: Colors.grey),
                  ),
                )
              else
                ...state.doneSessions.map((sessionDetail) {
                  final categoryName = sessionDetail.categoryName;
                  final tableName = sessionDetail.tableName;
                  final startTime = sessionDetail.startTime;
                  final endTime =
                      sessionDetail.actualEndTime ??
                      sessionDetail.expectedEndTime;
                  final totalPrice = sessionDetail.totalPrice;

                  String durationText = '';
                  if (endTime != null) {
                    final minutes = endTime.difference(startTime).inMinutes;
                    final hours = (minutes / 60).toStringAsFixed(1);
                    durationText = '$hours hrs';
                  }

                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (categoryIcons.containsKey(categoryName))
                                DecoratedCategoryIcon(
                                  data: categoryIcons[categoryName]!,
                                ),
                              if (categoryIcons.containsKey(categoryName))
                                SizedBox(width: 10.w),
                              Text(tableName, style: AppTextStyles.bold16),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  AutoSizeText(
                                    endTime != null
                                        ? '${formatTime12h(startTime)} - ${formatTime12h(endTime)}'
                                        : formatTime12h(startTime),
                                    style: AppTextStyles.bold14,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    endTime != null
                                        ? 'Duration'
                                        : 'Completed Session',
                                    style: AppTextStyles.regular14.copyWith(
                                      color: AppColors.grayDeep,
                                    ),
                                  ),
                                  if (durationText.isNotEmpty) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      durationText,
                                      style: AppTextStyles.regular14.copyWith(
                                        color: AppColors.grayDeep,
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
                                categoryName,
                                style: AppTextStyles.regular16.copyWith(
                                  color: AppColors.grayDeep,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Completed',
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
                                totalPrice != null
                                    ? '\$${totalPrice.toStringAsFixed(2)}'
                                    : 'No total recorded',
                                style: AppTextStyles.regular16.copyWith(
                                  color: AppColors.grayDeep,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
            ],
          );
        } else {
          return const Center(child: Text('Unknown error'));
        }
      },
    );
  }
}
