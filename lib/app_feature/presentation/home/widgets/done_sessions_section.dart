import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';

import 'package:pasta/app_feature/presentation/home/widgets/done_sessions_section_body.dart';
import 'package:pasta/app_feature/presentation/home/widgets/section_header.dart';
import 'package:pasta/core/routing/routes.dart';

class DoneSessionsSection extends StatelessWidget {
  const DoneSessionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionHeader(
          title: 'Done Sessions',
          onActionPressed: () => Navigator.pushNamed(
            context,
            Routes.doneSessionsView,
            arguments: context.read<HomeCubit>(),
          ),
        ),
        DoneSessionsSectionBody(),
      ],
    );
  }
}
