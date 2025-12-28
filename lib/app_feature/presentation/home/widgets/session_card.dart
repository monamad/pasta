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

  // ─────────────────────────────────────────────────────────────────
  // Display Condition Getters
  // ─────────────────────────────────────────────────────────────────
  bool get hasEndTime => expectedEndTime != null;
  bool get hasStarted => startTime.isBefore(DateTime.now());
  bool get showDuration => hasEndTime && !hasStarted;
  bool get showExtendButton => hasEndTime;

  // ─────────────────────────────────────────────────────────────────
  // Computed Values
  // ─────────────────────────────────────────────────────────────────
  double get durationHours =>
      expectedEndTime!.difference(startTime).inMinutes / 60;

  String get durationText => '$durationHours hrs';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 12.h),
            _buildCategoryStatusRow(),
            SizedBox(height: 12.h),
            _buildActionsRow(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Header Row: Icon + Title + Time Info
  // ─────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        DecoratedCategoryIcon(data: categoryIcons[category]!),
        SizedBox(width: 10.w),
        Text(
          title,
          style: AppTextStyles.bold16.copyWith(
            fontSize: MediaQuery.of(context).size.width > 400 ? 16 : 16.sp,
          ),
        ),
        const Spacer(),
        _SessionTimeInfo(
          hasStarted: hasStarted,
          hasEndTime: hasEndTime,
          showDuration: showDuration,
          startTime: startTime,
          expectedEndTime: expectedEndTime,
          sessionId: sessionId,
          durationText: durationText,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Category & Status Row
  // ─────────────────────────────────────────────────────────────────
  Widget _buildCategoryStatusRow() {
    return Row(
      children: [
        Text(
          category,
          style: AppTextStyles.regular16.copyWith(color: AppColors.grayDeep),
        ),
        const Spacer(),
        Text(
          status,
          style: AppTextStyles.regular16.copyWith(color: AppColors.grayDeep),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────
  // Actions Row: Price + Buttons
  // ─────────────────────────────────────────────────────────────────
  Widget _buildActionsRow() {
    return Row(
      children: [
        Text(
          price,
          style: AppTextStyles.regular16.copyWith(color: AppColors.grayDeep),
        ),
        const Spacer(),
        _SessionActions(
          showExtendButton: showExtendButton,
          onStop: onStop,
          onExtend: onExtend,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Private Widgets
// ═══════════════════════════════════════════════════════════════════

/// Displays timer (if started) or start time + duration (if not started)
class _SessionTimeInfo extends StatelessWidget {
  final bool hasStarted;
  final bool hasEndTime;
  final bool showDuration;
  final DateTime startTime;
  final DateTime? expectedEndTime;
  final int sessionId;
  final String durationText;

  const _SessionTimeInfo({
    required this.hasStarted,
    required this.hasEndTime,
    required this.showDuration,
    required this.startTime,
    required this.expectedEndTime,
    required this.sessionId,
    required this.durationText,
  });

  String get sessionTypeLabel => hasEndTime ? 'Duration' : 'Open Session';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildTimeDisplay(context),
        SizedBox(height: 4.h),
        AutoSizeText(
          sessionTypeLabel,
          style: AppTextStyles.regular14.copyWith(color: AppColors.grayDeep),
        ),
        if (showDuration) ...[
          SizedBox(height: 4.h),
          _buildDurationText(context),
        ],
      ],
    );
  }

  Widget _buildTimeDisplay(BuildContext context) {
    if (hasStarted) {
      return CountTimer(
        key: ValueKey(expectedEndTime),
        expectedEndTime: expectedEndTime,
        sessionId: sessionId,
        startedAt: startTime,
      );
    }

    return Text(
      'Starts at ${formatTime12h(startTime)}',
      style: AppTextStyles.bold14,
    );
  }

  Widget _buildDurationText(BuildContext context) {
    return Text(
      durationText,
      style: AppTextStyles.regular16.copyWith(
        color: AppColors.grayDeep,
        fontSize: MediaQuery.of(context).size.width > 400 ? 16 : 16.sp,
      ),
    );
  }
}

/// Stop and Extend buttons
class _SessionActions extends StatelessWidget {
  final bool showExtendButton;
  final VoidCallback onStop;
  final VoidCallback onExtend;

  const _SessionActions({
    required this.showExtendButton,
    required this.onStop,
    required this.onExtend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StopButton(onTap: onStop),
        if (showExtendButton) ...[
          SizedBox(width: 10.w),
          _ExtendButton(onTap: onExtend),
        ],
      ],
    );
  }
}

class _StopButton extends StatelessWidget {
  final VoidCallback onTap;

  const _StopButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Stop',
      width: 80.w,
      height: 30.h,
      textStyle: AppTextStyles.semiBold14.copyWith(color: AppColors.red),
      color: AppColors.pinkLight,
      onTap: onTap,
    );
  }
}

class _ExtendButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ExtendButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Extend',
      width: 80.w,
      height: 30.h,
      textStyle: AppTextStyles.semiBold14.copyWith(color: AppColors.primary),
      color: AppColors.blueSoft,
      onTap: onTap,
    );
  }
}
