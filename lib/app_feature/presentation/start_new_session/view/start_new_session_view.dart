import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/logic/start_new_session/start_new_session_cubit.dart';
import 'package:pasta/app_feature/presentation/home/widgets/custom_button.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/app_time_picker.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/custom_time_picker.dart';
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
      body: BlocListener<StartNewSessionCubit, StartNewSessionState>(
        listener: (context, state) {
          if (state is StartNewSessionSubmitted) {
            Navigator.of(context).pop();
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
        child: BlocBuilder<StartNewSessionCubit, StartNewSessionState>(
          builder: (context, state) {
            if (state is StartNewSessionLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is StartNewSessionError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is StartNewSessionDataLoaded) {
              if (state.availableTables.isEmpty) {
                return const Center(child: Text('No available tables.'));
              }
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text("Session Details", style: AppTextStyles.bold24),
                    const SizedBox(height: 20),
                    Text('Select Table', style: AppTextStyles.regular14),
                    const SizedBox(height: 10),
                    SelectTableSection(),
                    const SizedBox(height: 20),
                    Text('Start time', style: AppTextStyles.regular14),
                    const SizedBox(height: 10),
                    // Start Time
                    ValueListenableBuilder(
                      valueListenable: context
                          .read<StartNewSessionCubit>()
                          .startTime,
                      builder: (context, value, child) {
                        return AppTimePicker(
                          selectedTime: context
                              .read<StartNewSessionCubit>()
                              .startTime
                              .value,
                          onTap: () => _pickTime(context),
                        );
                      },
                    ),
                    const SizedBox(height: 20), // Session Type
                    Text('Session Type', style: AppTextStyles.regular14),
                    const SizedBox(height: 10),
                    ValueListenableBuilder(
                      valueListenable: context
                          .read<StartNewSessionCubit>()
                          .sessionType,
                      builder: (context, value, child) {
                        return SessionTypeSelector(
                          selectedType: context
                              .read<StartNewSessionCubit>()
                              .sessionType
                              .value,
                          onTypeChanged: (type) {
                            context
                                    .read<StartNewSessionCubit>()
                                    .sessionType
                                    .value =
                                type;
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: 20,
                    ), // Duration and Pricing (for hourly sessions)

                    SelectDurationSection(selectedCategory: selectedCategory),
                    const SizedBox(height: 20),

                    // Start Button
                    CustomButton(
                      text: 'Start Session',
                      onTap: () => _startSession(context),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showCustomTimePicker(
      context: context,
      initialTime: context.read<StartNewSessionCubit>().startTime.value,
      primaryColor: Theme.of(context).colorScheme.primary,
    );

    if (selectedTime != null) {
      // ignore: use_build_context_synchronously
      context.read<StartNewSessionCubit>().startTime.value = selectedTime;
    }
  }

  void _startSession(BuildContext context) {
    context.read<StartNewSessionCubit>().submitNewSession();
  }
}
