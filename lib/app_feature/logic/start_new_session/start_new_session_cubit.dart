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
  ValueNotifier<TimeOfDay> startTime = ValueNotifier(TimeOfDay.now());
  ValueNotifier<SessionType> sessionType = ValueNotifier(SessionType.hourly);
  ValueNotifier<double> duration = ValueNotifier(1.0);

  StartNewSessionCubit(this._tableRepository, this._sessionRepository)
    : super(StartNewSessionInitial());

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
        startTime: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          startTime.value.hour,
          startTime.value.minute,
          DateTime.now().second,
        ),
      );
      emit(StartNewSessionSubmitted());
    } catch (e) {
      emit(StartNewSessionSubmitError(e.toString(), availableTables));
    }
  }
}
