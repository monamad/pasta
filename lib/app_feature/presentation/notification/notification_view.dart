import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/logic/notification/notification_cubit.dart';
import 'package:pasta/core/helper/functions.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NotificationCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _scrollToHighlighted(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final itemHeight = 200.h; // Approximate height of card + separator
        final targetPosition = index * itemHeight;
        _scrollController.animateTo(
          targetPosition + 16.h,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

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

            // Scroll to highlighted item if present
            if (highlightId != null) {
              final highlightIndex = doneSessions.indexWhere(
                (s) => s.session.id == highlightId,
              );
              if (highlightIndex != -1) {
                _scrollToHighlighted(highlightIndex);
              }
            }

            return ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: doneSessions.length + (loadedState.hasMore ? 1 : 0),
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                // Show loading indicator at the bottom
                if (index >= doneSessions.length) {
                  return SizedBox();
                }

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
