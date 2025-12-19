import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/repos/session_repository.dart';
import 'package:pasta/app_feature/data/repos/table_repository.dart';
import 'package:pasta/app_feature/presentation/start_new_session/widgets/session_type_selector.dart';

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
      selectedTableId.value = tables.isNotEmpty ? tables.first.id : null;
      emit(StartNewSessionDataLoaded(tables));
    } catch (e) {
      emit(StartNewSessionError(e.toString()));
    }
  }

  Future<void> submitNewSession() async {
    if (state is! StartNewSessionDataLoaded) return;
    final availableTables =
        (state as StartNewSessionDataLoaded).availableTables;
    try {
      await _sessionRepository.startSession(
        tableId: selectedTableId.value!,
        durationHours: sessionType.value == SessionType.hourly
            ? duration.value
            : null,
        startTime: startTime.value ?? DateTime.now(),
      );
      emit(StartNewSessionSubmitted());
    } catch (e) {
      emit(StartNewSessionSubmitError(e.toString(), availableTables));
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
