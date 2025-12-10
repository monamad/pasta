import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/core/theme/app_style.dart';

class CountTimer extends StatefulWidget {
  final int sessionId;
  final int minutes;

  const CountTimer({super.key, required this.sessionId, required this.minutes});
  @override
  State<CountTimer> createState() => _CountTimerState();
}

class _CountTimerState extends State<CountTimer> {
  late int totalSeconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    totalSeconds = widget.minutes * 60;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (totalSeconds == 0) {
        setState(() {
          totalSeconds = -1;
        });
        t.cancel();
      } else {
        if (widget.minutes != 0) {
          setState(() {
            totalSeconds--;
          });
        } else {
          setState(() {
            totalSeconds++;
          });
        }
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
    if (totalSeconds == 0) {
      context.read<HomeCubit>().stopSession(widget.sessionId);
    }
    return Text(formatTime(totalSeconds), style: AppTextStyles.bold16);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
