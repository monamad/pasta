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
  final List<SessionWithDetails> reservedSessions;
  HomeLoaded({
    required this.activeSessions,
    required this.doneSessions,
    required this.categories,
    required this.totalBusyTables,
    required this.totalTodayRevenue,
    required this.reservedSessions,
  });

  HomeLoaded copyWith({
    List<SessionWithDetails>? activeSessions,
    List<SessionWithDetails>? doneSessions,
    List<CategoryData>? categories,
    int? totalBusyTables,
    double? totalTodayRevenue,
    List<SessionWithDetails>? reservedSessions,
  }) {
    return HomeLoaded(
      activeSessions: activeSessions ?? this.activeSessions,
      doneSessions: doneSessions ?? this.doneSessions,
      categories: categories ?? this.categories,
      totalBusyTables: totalBusyTables ?? this.totalBusyTables,
      totalTodayRevenue: totalTodayRevenue ?? this.totalTodayRevenue,
      reservedSessions: reservedSessions ?? this.reservedSessions,
    );
  }

  @override
  List<Object?> get props => [
    activeSessions,
    doneSessions,
    categories,
    totalBusyTables,
    totalTodayRevenue,
    reservedSessions,
  ];
}

final class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
