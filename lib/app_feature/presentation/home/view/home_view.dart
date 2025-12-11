import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
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
          padding: const EdgeInsets.all(16.0),
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
                    SizedBox(height: 20),
                    StatisticsSection(),
                    SizedBox(height: 10),
                    ActiveSessionsSection(),
                    SizedBox(height: 10),
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
