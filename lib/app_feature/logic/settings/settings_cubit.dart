import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pasta/app_feature/data/models/statistics_models.dart';
import 'package:pasta/app_feature/data/repos/statistics_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final StatisticsRepository _statisticsRepository;

  SettingsCubit(this._statisticsRepository) : super(const SettingsState());

  Future<void> loadStatistics() async {
    emit(state.copyWith(isLoading: true));
    try {
      final results = await Future.wait([
        _statisticsRepository.getOverallStats(),
        _statisticsRepository.getLast7DaysRevenue(),
        _statisticsRepository.getLast30DaysRevenue(),
        _statisticsRepository.getCategoryStats(),
        _statisticsRepository.getHourlyDistribution(),
      ]);

      emit(
        state.copyWith(
          isLoading: false,
          overallStats: results[0] as OverallStats,
          last7DaysRevenue: results[1] as List<DailyRevenue>,
          last30DaysRevenue: results[2] as List<DailyRevenue>,
          categoryStats: results[3] as List<CategoryStats>,
          hourlyDistribution: results[4] as List<HourlyDistribution>,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
