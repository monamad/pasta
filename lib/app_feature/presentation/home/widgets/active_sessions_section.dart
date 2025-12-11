import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/active_sessions_section_body.dart';
import 'package:pasta/app_feature/presentation/home/widgets/section_header.dart';
import 'package:pasta/core/routing/routes.dart';

class ActiveSessionsSection extends StatelessWidget {
  const ActiveSessionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Active Sessions',
          onActionPressed: () => Navigator.pushNamed(
            context,
            Routes.activeSessions,
            arguments: context.read<HomeCubit>(),
          ),
        ),
        ActiveSessionsSectionBody(),
      ],
    );
  }
}
