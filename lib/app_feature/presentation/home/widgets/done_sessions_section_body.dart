import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/decorated_category_icon.dart';
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
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'No done sessions',
                    style: AppTextStyles.regular14.copyWith(color: Colors.grey),
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

                  String formatTime(DateTime time) {
                    final hour = time.hour.toString().padLeft(2, '0');
                    final minute = time.minute.toString().padLeft(2, '0');
                    return '$hour:$minute';
                  }

                  String durationText = '';
                  if (endTime != null) {
                    final minutes = endTime.difference(startTime).inMinutes;
                    final hours = (minutes / 60).toStringAsFixed(1);
                    durationText = '$hours hrs';
                  }

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (categoryIcons.containsKey(categoryName))
                                DecoratedCategoryIcon(
                                  data: categoryIcons[categoryName]!,
                                ),
                              if (categoryIcons.containsKey(categoryName))
                                const SizedBox(width: 10),
                              Text(tableName, style: AppTextStyles.bold16),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    endTime != null
                                        ? '${formatTime(startTime)} - ${formatTime(endTime)}'
                                        : formatTime(startTime),
                                    style: AppTextStyles.bold14,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    endTime != null
                                        ? 'Duration'
                                        : 'Completed Session',
                                    style: AppTextStyles.regular12.copyWith(
                                      color: AppColors.grayDeep,
                                    ),
                                  ),
                                  if (durationText.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      durationText,
                                      style: AppTextStyles.regular12.copyWith(
                                        color: AppColors.grayDeep,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                categoryName,
                                style: AppTextStyles.regular14.copyWith(
                                  color: AppColors.grayDeep,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Completed',
                                style: AppTextStyles.regular14.copyWith(
                                  color: AppColors.grayDeep,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                totalPrice != null
                                    ? '\$${totalPrice.toStringAsFixed(2)}'
                                    : 'No total recorded',
                                style: AppTextStyles.regular14.copyWith(
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
