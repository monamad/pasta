import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/repos/session_repository.dart';
import 'package:pasta/app_feature/data/repos/table_repository.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/session_type_selector.dart';
import 'package:pasta/core/helper/functions.dart';

part 'start_new_session_state.dart';

class StartNewSessionCubit extends Cubit<StartNewSessionState> {
  final TableRepository _tableRepository;
  final SessionRepository _sessionRepository;
  ValueNotifier<int?> selectedTableId = ValueNotifier(null);
  ValueNotifier<DateTime?> startTime = ValueNotifier(null);
  ValueNotifier<SessionType> sessionType = ValueNotifier(SessionType.hourly);
  ValueNotifier<double> duration = ValueNotifier(1.0);

  StartNewSessionCubit(this._tableRepository, this._sessionRepository)
    : super(StartNewSessionInitial());

  @override
  Future<void> close() {
    selectedTableId.dispose();
    startTime.dispose();
    sessionType.dispose();
    duration.dispose();
    return super.close();
  }

  Future<void> loadAvailableTables(int categoryId) async {
    emit(StartNewSessionLoading());
    try {
      final tables = await _tableRepository.getAvailableByCategory(categoryId);
      final busyTables = await _tableRepository.getbusyTablesByCategory(
        categoryId,
      );

      // Select first available table, or first busy table if no available ones
      if (tables.isNotEmpty) {
        selectedTableId.value = tables.first.id;
      } else if (busyTables.isNotEmpty) {
        selectedTableId.value = busyTables.first.id;
      } else {
        selectedTableId.value = null;
      }

      emit(StartNewSessionDataLoaded(tables, busyTables));
    } catch (e) {
      emit(StartNewSessionError(e.toString()));
    }
  }

  Future<void> submitNewSession() async {
    final state = this.state;
    final List<GameTableData> availableTables;
    final List<GameTableData> busyTables;
    if (state is StartNewSessionDataLoaded) {
      final currentState = state;
      availableTables = currentState.availableTables;
      busyTables = currentState.busyTables;
    } else if (state is StartNewSessionSubmitError) {
      final currentState = state;
      availableTables = currentState.availableTables;
      busyTables = currentState.busyTables;
    } else {
      emit(StartNewSessionError('Invalid state for submission'));
      return;
    }

    try {
      await _sessionRepository.startSession(
        tableId: selectedTableId.value!,
        durationHours: sessionType.value == SessionType.hourly
            ? duration.value
            : null,
        startTime: removeMilliseconds(startTime.value ?? DateTime.now()),
      );
      emit(StartNewSessionSubmitted());
    } on ReservationConflictException catch (e) {
      final conflictMessages = e.conflicts
          .map((conflict) {
            final startTimeStr = formatTime(conflict.startTime);
            final endTimeStr = formatTime(conflict.endTime);

            return '$startTimeStr to $endTimeStr';
          })
          .join('\\n');

      final message = e.conflicts.length == 1
          ? 'This table is already reserved:\\n$conflictMessages'
          : 'This table has ${e.conflicts.length} conflicting reservations:\\n$conflictMessages';
      emit(StartNewSessionSubmitError(message, availableTables, busyTables));
    } catch (e) {
      emit(
        StartNewSessionSubmitError(e.toString(), availableTables, busyTables),
      );
    }
  }

  void assignNewStartTime(TimeOfDay? time) {
    if (time == null) return;

    final now = DateTime.now();

    DateTime selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      0,
    );

    if (selectedDateTime.isBefore(now)) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }

    startTime.value = selectedDateTime;
  }
}
