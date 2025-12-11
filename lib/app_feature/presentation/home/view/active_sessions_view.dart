import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/active_sessions_section_body.dart';

class ActiveSessionsView extends StatelessWidget {
  final HomeCubit homeCubit;

  const ActiveSessionsView({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Active Sessions')),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: ActiveSessionsSectionBody(),
        ),
      ),
    );
  }
}
