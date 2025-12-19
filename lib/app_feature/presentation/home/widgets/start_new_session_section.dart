import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/presentation/home/widgets/section_header.dart';
import 'package:pasta/app_feature/presentation/home/widgets/start_new_session_grid.dart';

class StartNewSessionSection extends StatelessWidget {
  const StartNewSessionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //start new session header
        SectionHeader(title: 'Start New Session'),
        //start new session grid
        SizedBox(height: 10.h),
        StartNewSessionGrid(),
      ],
    );
  }
}
