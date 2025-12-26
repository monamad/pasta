import 'package:pasta/app_feature/data/data_base/daos/session_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/category_dao.dart';
import 'package:pasta/app_feature/data/data_base/daos/table_dao.dart';
import 'package:pasta/app_feature/data/models/statistics_models.dart';
import 'package:pasta/core/helper/functions.dart';

class StatisticsRepository {
  final ISessionDao _sessionDao;
  final ICategoryDao _categoryDao;
  final ITableDao _tableDao;

  StatisticsRepository(this._sessionDao, this._categoryDao, this._tableDao);

  Future<OverallStats> getOverallStats() async {
    final now = DateTime.now();

    // Today
    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);

    // This week (Monday to Sunday)
    final weekStart = todayStart.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(
      const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
    );

    // This month
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final todaySessions = await _sessionDao.getSessionsByDateRange(
      todayStart,
      todayEnd,
    );
    final weekSessions = await _sessionDao.getSessionsByDateRange(
      weekStart,
      weekEnd,
    );
    final monthSessions = await _sessionDao.getSessionsByDateRange(
      monthStart,
      monthEnd,
    );

    final todayRevenue = todaySessions.fold<double>(
      0,
      (sum, s) => sum + (s.totalPrice ?? 0),
    );
    final weekRevenue = weekSessions.fold<double>(
      0,
      (sum, s) => sum + (s.totalPrice ?? 0),
    );
    final monthRevenue = monthSessions.fold<double>(
      0,
      (sum, s) => sum + (s.totalPrice ?? 0),
    );

    // Calculate average session duration
    double totalDuration = 0;
    int validSessions = 0;
    for (final session in monthSessions) {
      if (session.actualEndTime != null) {
        totalDuration += session.actualEndTime!
            .difference(session.startTime)
            .inMinutes;
        validSessions++;
      }
    }
    final avgDuration = validSessions > 0 ? totalDuration / validSessions : 0.0;

    // Get category stats for most popular
    final categoryStats = await getCategoryStats();
    String mostPopular = 'N/A';
    if (categoryStats.isNotEmpty) {
      categoryStats.sort((a, b) => b.sessionCount.compareTo(a.sessionCount));
      mostPopular = categoryStats.first.categoryName;
    }

    // Get hourly distribution for busiest hour
    final hourlyDist = await getHourlyDistribution();
    String busiestHour = 'N/A';
    if (hourlyDist.isNotEmpty) {
      hourlyDist.sort((a, b) => b.sessionCount.compareTo(a.sessionCount));
      final hour = hourlyDist.first.hour;
      busiestHour =
          '${formatTime12hFromHours(hour)} - ${formatTime12hFromHours((hour + 1) % 24)}';
    }

    return OverallStats(
      todayRevenue: todayRevenue,
      weekRevenue: weekRevenue,
      monthRevenue: monthRevenue,
      todaySessions: todaySessions.length,
      weekSessions: weekSessions.length,
      monthSessions: monthSessions.length,
      averageSessionDuration: avgDuration,
      mostPopularCategory: mostPopular,
      busiestHour: busiestHour,
    );
  }

  Future<List<DailyRevenue>> getLast7DaysRevenue() async {
    final now = DateTime.now();
    final List<DailyRevenue> result = [];

    for (int i = 6; i >= 0; i--) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final sessions = await _sessionDao.getSessionsByDateRange(date, endDate);
      final revenue = sessions.fold<double>(
        0,
        (sum, s) => sum + (s.totalPrice ?? 0),
      );

      result.add(
        DailyRevenue(
          date: date,
          revenue: revenue,
          sessionCount: sessions.length,
        ),
      );
    }

    return result;
  }

  Future<List<DailyRevenue>> getLast30DaysRevenue() async {
    final now = DateTime.now();
    final List<DailyRevenue> result = [];

    for (int i = 29; i >= 0; i--) {
      final date = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(Duration(days: i));
      final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final sessions = await _sessionDao.getSessionsByDateRange(date, endDate);
      final revenue = sessions.fold<double>(
        0,
        (sum, s) => sum + (s.totalPrice ?? 0),
      );

      result.add(
        DailyRevenue(
          date: date,
          revenue: revenue,
          sessionCount: sessions.length,
        ),
      );
    }

    return result;
  }

  Future<List<CategoryStats>> getCategoryStats() async {
    final categories = await _categoryDao.getAllCategories();
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final allSessions = await _sessionDao.getSessionsByDateRange(
      monthStart,
      monthEnd,
    );
    final List<CategoryStats> result = [];

    for (final category in categories) {
      double totalRevenue = 0;
      double totalMinutes = 0;
      int sessionCount = 0;

      // Get sessions that match this category by joining through the table
      for (final session in allSessions) {
        // Get the table for this session
        final table = await _tableDao.getTableById(session.tableId);

        // Check if this session's table belongs to the current category
        if (table != null && table.categoryId == category.id) {
          sessionCount++;
          totalRevenue += session.totalPrice ?? 0;
          if (session.actualEndTime != null) {
            totalMinutes += session.actualEndTime!
                .difference(session.startTime)
                .inMinutes;
          }
        }
      }

      result.add(
        CategoryStats(
          categoryName: category.name,
          sessionCount: sessionCount,
          totalRevenue: totalRevenue,
          totalHours: totalMinutes / 60,
        ),
      );
    }

    return result;
  }

  Future<List<HourlyDistribution>> getHourlyDistribution() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final sessions = await _sessionDao.getSessionsByDateRange(
      monthStart,
      monthEnd,
    );
    final Map<int, int> hourCounts = {};

    for (int i = 0; i < 24; i++) {
      hourCounts[i] = 0;
    }

    for (final session in sessions) {
      final hour = session.startTime.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    return hourCounts.entries
        .map((e) => HourlyDistribution(hour: e.key, sessionCount: e.value))
        .toList()
      ..sort((a, b) => a.hour.compareTo(b.hour));
  }
}
