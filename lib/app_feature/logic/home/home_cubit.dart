import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/repos/category_repository.dart';
import 'package:pasta/app_feature/data/repos/session_repository.dart';
import 'package:pasta/app_feature/data/repos/table_repository.dart';
import 'package:pasta/app_feature/data/session_model_with_details.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final TableRepository _tableRepository;
  final CategoryRepository _categoryRepository;
  final SessionRepository _sessionRepository;
  HomeCubit(
    this._tableRepository,
    this._categoryRepository,
    this._sessionRepository,
  ) : super(HomeInitial());
  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final results = await Future.wait([
        _categoryRepository.getAll(),
        _tableRepository.numberOfBusyTables(),
        _sessionRepository.getTotalTodayRevenue(),
        _sessionRepository.getRunning(),
        _sessionRepository.getDoneSessions(),
      ]);

      final categories = results[0] as List<CategoryData>;
      final totalBusyTables = results[1] as int;

      emit(
        HomeLoaded(
          activeSessions: results[3] as List<SessionWithDetails>,
          doneSessions: results[4] as List<SessionWithDetails>,
          categories: categories,
          totalBusyTables: totalBusyTables,
          totalTodayRevenue: results[2] as double,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> getAllCategories() async {
    if (state is! HomeLoaded) return;
    emit(
      (state as HomeLoaded).copyWith(
        categories: await _categoryRepository.getAll(),
      ),
    );
  }

  Future<void> getNumberOfBusyTables() async {
    if (state is! HomeLoaded) return;
    emit(
      (state as HomeLoaded).copyWith(
        totalBusyTables: await _tableRepository.numberOfBusyTables(),
      ),
    );
  }

  Future<void> getTotalTodayRevenue() async {
    if (state is! HomeLoaded) return;
    emit(
      (state as HomeLoaded).copyWith(
        totalTodayRevenue: await _sessionRepository.getTotalTodayRevenue(),
      ),
    );
  }

  Future<void> getRunningSessions() async {
    if (state is! HomeLoaded) return;
    final updatedSessions = await _sessionRepository.getRunning();

    emit(
      (state as HomeLoaded).copyWith(
        activeSessions: List.from(updatedSessions),
      ),
    );
  }

  Future<void> getDoneSessions() async {
    if (state is! HomeLoaded) return;
    final updatedSessions = await _sessionRepository.getDoneSessions();

    emit(
      (state as HomeLoaded).copyWith(doneSessions: List.from(updatedSessions)),
    );
  }

  Future<void> stopSession(int sessionId) async {
    await _sessionRepository.endSession(sessionId);
    await getRunningSessions();
    await getTotalTodayRevenue();
    await getNumberOfBusyTables();
    await getDoneSessions();
  }

  Future<void> extendSession(int sessionId, int additionalMinutes) async {
    await _sessionRepository.extendSession(sessionId, additionalMinutes);
    await getRunningSessions();
  }
}
