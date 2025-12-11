import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/done_sessions_section_body.dart';

class DoneSessionsSectionView extends StatelessWidget {
  final HomeCubit homeCubit;

  const DoneSessionsSectionView({super.key, required this.homeCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Done Sessions')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: DoneSessionsSectionBody(),
        ),
      ),
    );
  }
}
