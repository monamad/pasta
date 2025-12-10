import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/section_header.dart';
import 'package:pasta/app_feature/presentation/home/widgets/session_card.dart';
import 'package:pasta/core/theme/app_style.dart';

class ActiveSessionsSection extends StatelessWidget {
  const ActiveSessionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          return Column(
            children: [
              SectionHeader(title: 'Active Sessions'),
              if (state.activeSessions.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'No active sessions',
                    style: AppTextStyles.regular14.copyWith(color: Colors.grey),
                  ),
                )
              else
                ...state.activeSessions.map((sessionDetail) {
                  final categoryName = sessionDetail.categoryName;
                  return SessionCard(
                    sessionId: sessionDetail.session.id,
                    title: sessionDetail.tableName,
                    duration: sessionDetail.session.durationMinutes != null
                        ? '${sessionDetail.session.durationMinutes} min'
                        : null,
                    category: categoryName,
                    status: 'Running',
                    price:
                        '\$${sessionDetail.pricePerHour.toStringAsFixed(0)}/hour',
                    onStop: () {
                      context.read<HomeCubit>().stopSession(
                        sessionDetail.session.id,
                      );
                    },
                    onExtend: () {
                      //todo
                      // Extend by 30 minutes
                      // context.read<HomeCubit>().extendSession(
                      //   sessionDetail.session.id,
                      //   30,
                      // );
                    },
                  );
                }),
            ],
          );
        } else {
          return Center(child: Text('Unknown error'));
        }
      },
    );
  }
}
