import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/logic/notification/notification_cubit.dart';
import 'package:pasta/core/helper/functions.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications', style: AppTextStyles.bold18)),
      body: RefreshIndicator(
        onRefresh: () => context.read<NotificationCubit>().load(),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading || state is NotificationInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError) {
              return Center(child: Text(state.message));
            }

            final loadedState = state as NotificationLoaded;
            final doneSessions = loadedState.doneSessions;
            final highlightId = loadedState.highlightSessionId;
            if (doneSessions.isEmpty) {
              return const Center(child: Text('No notifications yet'));
            }

            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: doneSessions.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final session = doneSessions[index];
                final isHighlighted =
                    highlightId != null && session.session.id == highlightId;
                final durationMinutes = session.actualEndTime != null
                    ? session.actualEndTime!
                          .difference(session.startTime)
                          .inMinutes
                    : 0;
                final duration = Duration(minutes: durationMinutes);
                final durationText =
                    "${duration.inHours.toString().padLeft(2, '0')}:"
                    "${(duration.inMinutes % 60).toString().padLeft(2, '0')}";

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isHighlighted
                        ? AppColors.blueDark.withValues(alpha: .5)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Card(
                    color: Colors.transparent,
                    elevation: isHighlighted ? 2 : null,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Session ended', style: AppTextStyles.bold16),
                          SizedBox(height: 8.h),
                          Text(
                            '${session.tableName} • ${session.categoryName}',
                            style: AppTextStyles.regular16,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Start: ${formatDateTime(session.startTime)}',
                            style: AppTextStyles.regular16,
                          ),
                          SizedBox(height: 4.h),
                          if (session.actualEndTime != null)
                            Text(
                              'End:   ${formatDateTime(session.actualEndTime!)}',
                              style: AppTextStyles.regular16,
                            ),
                          SizedBox(height: 4.h),
                          if (session.expectedEndTime != null &&
                              session.expectedEndTime != session.actualEndTime)
                            Text(
                              'Expected: ${formatDateTime(session.expectedEndTime!)}',
                              style: AppTextStyles.regular14,
                            ),
                          SizedBox(height: 8.h),
                          Text(
                            'Duration: $durationText',
                            style: AppTextStyles.regular14,
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Price/hr: ${session.hourPrice.toStringAsFixed(2)}    Total: ${(session.totalPrice ?? 0).toStringAsFixed(2)}',
                            style: AppTextStyles.bold14,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
