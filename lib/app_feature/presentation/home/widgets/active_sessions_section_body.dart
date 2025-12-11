import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/session_card.dart';
import 'package:pasta/core/theme/app_style.dart';

class ActiveSessionsSectionBody extends StatelessWidget {
  const ActiveSessionsSectionBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return Column(
            children: [
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
                    startTime: sessionDetail.session.startTime,
                    expectedEndTime: sessionDetail.session.expectedEndTime,
                    category: categoryName,
                    status: 'Running',
                    price:
                        '\$${sessionDetail.pricePerHour.toStringAsFixed(0)}/hour',
                    onStop: () {
                      context.read<HomeCubit>().stopSession(
                        sessionDetail.session.id,
                      );
                    },
                    onExtend: () async {
                      await _showExtendDialog(
                        context,
                        sessionDetail.session.id,
                        sessionDetail.tableName,
                      );
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

  Future<void> _showExtendDialog(
    BuildContext context,
    int sessionId,
    String tableName,
  ) async {
    BuildContext appContext = context;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Extend Session'),
          content: Text('Do you want to extend $tableName by 30 minutes?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                appContext.read<HomeCubit>().extendSession(sessionId, 30);

                Navigator.of(context).pop();
              },
              child: Text('Extend'),
            ),
          ],
        );
      },
    );
  }
}
