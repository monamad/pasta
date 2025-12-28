import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/reserved_sessions_body.dart';

class ReservedSessionsView extends StatelessWidget {
  final HomeCubit homeCubit;

  const ReservedSessionsView({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Reserved Sessions')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: ReservedSessionsBody(),
        ),
      ),
    );
  }
}
