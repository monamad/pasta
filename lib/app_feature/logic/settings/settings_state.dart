part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final bool isLoading;
  final String? error;
  final OverallStats? overallStats;
  final List<DailyRevenue> last7DaysRevenue;
  final List<DailyRevenue> last30DaysRevenue;
  final List<CategoryStats> categoryStats;
  final List<HourlyDistribution> hourlyDistribution;

  const SettingsState({
    this.isLoading = false,
    this.error,
    this.overallStats,
    this.last7DaysRevenue = const [],
    this.last30DaysRevenue = const [],
    this.categoryStats = const [],
    this.hourlyDistribution = const [],
  });

  SettingsState copyWith({
    bool? isLoading,
    String? error,
    OverallStats? overallStats,
    List<DailyRevenue>? last7DaysRevenue,
    List<DailyRevenue>? last30DaysRevenue,
    List<CategoryStats>? categoryStats,
    List<HourlyDistribution>? hourlyDistribution,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      overallStats: overallStats ?? this.overallStats,
      last7DaysRevenue: last7DaysRevenue ?? this.last7DaysRevenue,
      last30DaysRevenue: last30DaysRevenue ?? this.last30DaysRevenue,
      categoryStats: categoryStats ?? this.categoryStats,
      hourlyDistribution: hourlyDistribution ?? this.hourlyDistribution,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    error,
    overallStats,
    last7DaysRevenue,
    last30DaysRevenue,
    categoryStats,
    hourlyDistribution,
  ];
}
