import 'package:equatable/equatable.dart';

class DailyRevenue extends Equatable {
  final DateTime date;
  final double revenue;
  final int sessionCount;

  const DailyRevenue({
    required this.date,
    required this.revenue,
    required this.sessionCount,
  });

  @override
  List<Object?> get props => [date, revenue, sessionCount];
}

class CategoryStats extends Equatable {
  final String categoryName;
  final int sessionCount;
  final double totalRevenue;
  final double totalHours;

  const CategoryStats({
    required this.categoryName,
    required this.sessionCount,
    required this.totalRevenue,
    required this.totalHours,
  });

  @override
  List<Object?> get props => [
    categoryName,
    sessionCount,
    totalRevenue,
    totalHours,
  ];
}

class HourlyDistribution extends Equatable {
  final int hour;
  final int sessionCount;

  const HourlyDistribution({required this.hour, required this.sessionCount});

  @override
  List<Object?> get props => [hour, sessionCount];
}

class OverallStats extends Equatable {
  final double todayRevenue;
  final double weekRevenue;
  final double monthRevenue;
  final int todaySessions;
  final int weekSessions;
  final int monthSessions;
  final double averageSessionDuration;
  final String mostPopularCategory;
  final String busiestHour;

  const OverallStats({
    required this.todayRevenue,
    required this.weekRevenue,
    required this.monthRevenue,
    required this.todaySessions,
    required this.weekSessions,
    required this.monthSessions,
    required this.averageSessionDuration,
    required this.mostPopularCategory,
    required this.busiestHour,
  });

  @override
  List<Object?> get props => [
    todayRevenue,
    weekRevenue,
    monthRevenue,
    todaySessions,
    weekSessions,
    monthSessions,
    averageSessionDuration,
    mostPopularCategory,
    busiestHour,
  ];
}
