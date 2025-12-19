import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/logic/start_new_session/start_new_session_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/custom_button.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/app_time_picker.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/select_duration_section.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/select_table_section.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/session_type_selector.dart';
import 'package:pasta/core/theme/app_style.dart';

class StartNewSessionView extends StatelessWidget {
  final CategoryData selectedCategory;
  const StartNewSessionView({super.key, required this.selectedCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start New Session')),
      body: BlocConsumer<StartNewSessionCubit, StartNewSessionState>(
        buildWhen: (previous, current) => current is! StartNewSessionSubmitted,
        listener: (context, state) {
          if (state is StartNewSessionSubmitted) {
            Navigator.of(context).pop(true);
          } else if (state is StartNewSessionSubmitError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is StartNewSessionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<StartNewSessionCubit>();

          if (state is StartNewSessionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StartNewSessionError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is StartNewSessionDataLoaded &&
              state.availableTables.isEmpty) {
            return const Center(child: Text('No available tables.'));
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Text("Session Details", style: AppTextStyles.bold24),
                  SizedBox(height: 20.h),
                  Text('Select Table', style: AppTextStyles.regular16),
                  SizedBox(height: 10.h),
                  SelectTableSection(),
                  SizedBox(height: 20.h),
                  Text('Start time', style: AppTextStyles.regular16),
                  SizedBox(height: 10.h),
                  // Start Time
                  ValueListenableBuilder<DateTime?>(
                    valueListenable: cubit.startTime,
                    builder: (context, selectedTime, child) {
                      return AppTimePicker(
                        selectedTime: TimeOfDay.fromDateTime(
                          selectedTime ?? DateTime.now(),
                        ),
                        onTap: () => _pickTime(context, cubit),
                      );
                    },
                  ),
                  SizedBox(height: 20.h), // Session Type
                  Text('Session Type', style: AppTextStyles.regular16),
                  SizedBox(height: 10.h),
                  ValueListenableBuilder<SessionType>(
                    valueListenable: cubit.sessionType,
                    builder: (context, selectedType, child) {
                      return SessionTypeSelector(
                        selectedType: selectedType,
                        onTypeChanged: (type) {
                          cubit.sessionType.value = type;
                        },
                      );
                    },
                  ),
                  SizedBox(height: 20.h),
                  // Duration and Pricing (for hourly sessions)
                  SelectDurationSection(selectedCategory: selectedCategory),
                  SizedBox(height: 20.h),
                  // Start Button
                  CustomButton(
                    text: 'Start Session',
                    onTap: () => _startSession(context),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickTime(
    BuildContext context,
    StartNewSessionCubit cubit,
  ) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        cubit.startTime.value ?? DateTime.now(),
      ),
    );

    if (selectedTime != null) {
      cubit.assignNewStartTime(selectedTime);
    }
  }

  void _startSession(BuildContext context) {
    context.read<StartNewSessionCubit>().submitNewSession();
  }
}
