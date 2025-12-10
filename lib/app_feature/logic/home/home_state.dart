part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoaded extends HomeState {
  final List<SessionWithDetails> activeSessions;
  final List<CategoryData> categories;
  final int totalBusyTables;
  final double totalTodayRevenue;
  HomeLoaded({
    required this.activeSessions,
    required this.categories,
    required this.totalBusyTables,
    required this.totalTodayRevenue,
  });
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
