import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/logic/start_new_session/start_new_session_cubit.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/duration_selector.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/session_pricing_summary.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/session_type_selector.dart';

class SelectDurationSection extends StatelessWidget {
  final CategoryData selectedCategory;
  const SelectDurationSection({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<StartNewSessionCubit>().sessionType,
      builder: (context, value, child) {
        return Column(
          children: [
            if (value == SessionType.hourly) ...[
              ValueListenableBuilder(
                valueListenable: context.read<StartNewSessionCubit>().duration,
                builder: (context, value, child) {
                  return DurationSelector(
                    duration: context
                        .read<StartNewSessionCubit>()
                        .duration
                        .value,
                    onDurationChanged: (newDuration) {
                      context.read<StartNewSessionCubit>().duration.value =
                          newDuration;
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),
              ValueListenableBuilder(
                valueListenable: context.read<StartNewSessionCubit>().duration,
                builder: (context, value, child) {
                  return SessionPricingSummary(
                    ratePerHour: selectedCategory.pricePerHour,
                    estimatedTotal:
                        selectedCategory.pricePerHour *
                        context.read<StartNewSessionCubit>().duration.value,
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}
