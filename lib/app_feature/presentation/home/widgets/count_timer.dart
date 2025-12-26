import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/core/theme/app_style.dart';

class CountTimer extends StatefulWidget {
  final int sessionId;
  final DateTime startedAt;
  final DateTime? expectedEndTime;

  const CountTimer({
    super.key,
    required this.sessionId,
    required this.startedAt,
    required this.expectedEndTime,
  });
  @override
  State<CountTimer> createState() => _CountTimerState();
}

class _CountTimerState extends State<CountTimer> {
  late int totalSeconds;
  Timer? timer;
  late bool isCountDown;

  @override
  void initState() {
    super.initState();
    totalSeconds = widget.expectedEndTime != null
        ? widget.expectedEndTime!.difference(DateTime.now()).inSeconds
        : DateTime.now().difference(widget.startedAt).inSeconds;
    isCountDown = widget.expectedEndTime != null;
    if (isCountDown) {
      if (totalSeconds <= 0) {
        totalSeconds = 0;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          context.read<HomeCubit>().stopSession(widget.sessionId);
        });
        return;
      }
    } else {
      if (totalSeconds < 0) {
        totalSeconds = 0;
      }
    }

    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        timer?.cancel();
        return;
      }
      if (isCountDown) {
        if (totalSeconds == 0 && isCountDown) {
          timer?.cancel();
          context.read<HomeCubit>().stopSession(widget.sessionId);
          return;
        }
        setState(() {
          totalSeconds--;
        });
      } else {
        setState(() {
          totalSeconds++;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;

    return "${h.toString().padLeft(2, '0')}:"
        "${m.toString().padLeft(2, '0')}:"
        "${s.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      formatTime(totalSeconds),
      maxLines: 1,
      maxFontSize: 20,
      stepGranularity: 1,
      style: AppTextStyles.bold16.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
        fontSize: MediaQuery.of(context).size.width > 400 ? 16 : 16.sp,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
