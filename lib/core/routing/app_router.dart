import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/data/repos/category_repository.dart';
import 'package:pasta/app_feature/data/repos/session_repository.dart';
import 'package:pasta/app_feature/data/repos/statistics_repository.dart';
import 'package:pasta/app_feature/data/repos/table_repository.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/app_feature/logic/notification/notification_cubit.dart';
import 'package:pasta/app_feature/logic/settings/settings_cubit.dart';
import 'package:pasta/app_feature/logic/start_new_session/start_new_session_cubit.dart';
import 'package:pasta/app_feature/presentation/home/view/active_sessions_view.dart';
import 'package:pasta/app_feature/presentation/home/view/done_sessions_section_view.dart';
import 'package:pasta/app_feature/presentation/home/view/home_view.dart';
import 'package:pasta/app_feature/presentation/home/view/reserved_sessions_view.dart';
import 'package:pasta/app_feature/presentation/notification/notification_view.dart';
import 'package:pasta/app_feature/presentation/settings/settings_view.dart';
import 'package:pasta/app_feature/presentation/start_new_session/view/start_new_session_view.dart';
import 'package:pasta/core/di/service_locator.dart';
import 'package:pasta/core/routing/routes.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(
              getIt<CategoryRepository>(),
              getIt<SessionRepository>(),
            )..loadHomeData(),
            child: HomeView(),
          ),
        );
      case Routes.notifications:
        final highlightSessionId = settings.arguments is int
            ? settings.arguments as int
            : null;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                NotificationCubit(getIt<SessionRepository>())
                  ..load(highlightSessionId: highlightSessionId),
            child: const NotificationView(),
          ),
        );
      case Routes.startNewSession:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => StartNewSessionCubit(
              getIt<TableRepository>(),
              getIt<SessionRepository>(),
            )..loadAvailableTables((settings.arguments as CategoryData).id),
            child: StartNewSessionView(
              selectedCategory: settings.arguments as CategoryData,
            ),
          ),
        );
      case Routes.activeSessions:
        final homeCubit = settings.arguments as HomeCubit;
        return MaterialPageRoute(
          builder: (_) => ActiveSessionsView(homeCubit: homeCubit),
        );

      case Routes.reservedSessions:
        final homeCubit = settings.arguments as HomeCubit;
        return MaterialPageRoute(
          builder: (_) => ReservedSessionsView(homeCubit: homeCubit),
        );
      case Routes.doneSessionsView:
        final homeCubit = settings.arguments as HomeCubit;
        return MaterialPageRoute(
          builder: (_) => DoneSessionsSectionView(homeCubit: homeCubit),
        );
      case Routes.settings:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                SettingsCubit(getIt<StatisticsRepository>())..loadStatistics(),
            child: const SettingsView(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
