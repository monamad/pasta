part of 'home_cubit.dart';

@immutable
sealed class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<SessionWithDetails> activeSessions;
  final List<SessionWithDetails> doneSessions;
  final List<CategoryData> categories;
  final int totalBusyTables;
  final double totalTodayRevenue;
  HomeLoaded({
    required this.activeSessions,
    required this.doneSessions,
    required this.categories,
    required this.totalBusyTables,
    required this.totalTodayRevenue,
  });

  HomeLoaded copyWith({
    List<SessionWithDetails>? activeSessions,
    List<SessionWithDetails>? doneSessions,
    List<CategoryData>? categories,
    int? totalBusyTables,
    double? totalTodayRevenue,
  }) {
    return HomeLoaded(
      activeSessions: activeSessions ?? this.activeSessions,
      doneSessions: doneSessions ?? this.doneSessions,
      categories: categories ?? this.categories,
      totalBusyTables: totalBusyTables ?? this.totalBusyTables,
      totalTodayRevenue: totalTodayRevenue ?? this.totalTodayRevenue,
    );
  }

  @override
  List<Object?> get props => [
    activeSessions,
    doneSessions,
    categories,
    totalBusyTables,
    totalTodayRevenue,
  ];
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
