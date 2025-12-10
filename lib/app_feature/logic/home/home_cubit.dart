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
      ]);

      final categories = results[0] as List<CategoryData>;
      final totalBusyTables = results[1] as int;

      var x = await _sessionRepository.getAllSessions();
      print(x);
      emit(
        HomeLoaded(
          activeSessions: results[3] as List<SessionWithDetails>,
          categories: categories,
          totalBusyTables: totalBusyTables,
          totalTodayRevenue: results[2] as double,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> stopSession(int sessionId) async {
    await _sessionRepository.endSession(sessionId);
    loadHomeData();
  }
}
