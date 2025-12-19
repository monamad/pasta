import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/logic/start_new_session/start_new_session_cubit.dart';
import 'package:pasta/core/theme/app_colors.dart';

class SelectTableSection extends StatelessWidget {
  const SelectTableSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<StartNewSessionCubit, StartNewSessionState>(
      builder: (context, state) {
        if (state is StartNewSessionLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is StartNewSessionError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is StartNewSessionDataLoaded ||
            state is StartNewSessionSubmitError) {
          final tables = state is StartNewSessionDataLoaded
              ? state.availableTables
              : (state as StartNewSessionSubmitError).availableTables;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tables.map((table) {
              return ValueListenableBuilder(
                valueListenable: context
                    .read<StartNewSessionCubit>()
                    .selectedTableId,
                builder: (context, value, child) {
                  final isSelected = value == table.id;
                  return ChoiceChip(
                    label: Text(table.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      context
                              .read<StartNewSessionCubit>()
                              .selectedTableId
                              .value =
                          table.id;
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : isSelected
                          ? Colors.white
                          : Colors.black,
                    ),
                  );
                },
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text('No tables available'));
        }
      },
    );
  }
}
