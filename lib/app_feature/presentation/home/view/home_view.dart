import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/reserved_sessions_body.dart';
import 'package:pasta/app_feature/presentation/home/widgets/start_new_session_section.dart';
import 'package:pasta/app_feature/presentation/home/widgets/active_sessions_section.dart';
import 'package:pasta/app_feature/presentation/home/widgets/done_sessions_section.dart';
import 'package:pasta/app_feature/presentation/home/widgets/custom_app_bar.dart';
import 'package:pasta/app_feature/presentation/home/widgets/statistics_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeCubit>().loadHomeData();
        },

        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    StartNewSessionSection(),
                    SizedBox(height: 20.h),
                    StatisticsSection(),
                    SizedBox(height: 10.h),
                    ActiveSessionsSection(),
                    SizedBox(height: 10.h),
                    ReservedSessionsBody(),
                    SizedBox(height: 10.h),
                    DoneSessionsSection(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
