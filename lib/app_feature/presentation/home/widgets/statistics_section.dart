import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/stat_card.dart';
import 'package:pasta/core/theme/app_colors.dart';

class StatisticsSection extends StatelessWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: StatCard(
                  backgroundColor: AppColors.blueLighter,
                  iconColor: AppColors.primary,
                  icon: Icons.play_arrow,
                  statusText: 'Active',
                  statusColor: AppColors.primary,
                  value: '${state.totalBusyTables}',
                  label: 'Running Sessions',
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: StatCard(
                  backgroundColor: AppColors.greenSoft,
                  iconColor: AppColors.green,
                  icon: Icons.attach_money,
                  statusText: 'Active',
                  statusColor: AppColors.green,
                  value: '\$${state.totalTodayRevenue.toStringAsFixed(2)}',
                  label: 'Revenue',
                ),
              ),
            ],
          );
        }
        return Center(
          child: Text(state is HomeError ? state.message : 'Unknown error'),
        );
      },
    );
  }
}
