import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/data/repos/category_repository.dart';
import 'package:pasta/app_feature/data/repos/table_repository.dart';
import 'package:pasta/core/di/service_locator.dart';
import 'package:pasta/core/extension/context_extention.dart';
import 'package:pasta/core/notifications/local_notification_service.dart';
import 'package:pasta/core/routing/app_router.dart';
import 'package:pasta/core/routing/routes.dart';
import 'package:pasta/core/theme/app_theme.dart';
import 'package:pasta/core/theme/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await setupServiceLocator();
  await getIt<ILocalNotificationService>().init();
  await _seedData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => ThemeCubit(getIt<SharedPreferences>()),
          child: BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp(
                navigatorKey: NavigationService.navigatorKey,
                themeMode: themeMode,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                onGenerateRoute: AppRouter.generateRoute,
                initialRoute: Routes.home,
              );
            },
          ),
        );
      },
    );
  }
}

Future<void> _seedData() async {
  final categoryRepo = getIt<CategoryRepository>();
  final tableRepo = getIt<TableRepository>();

  // Check if data already exists
  final existingCategories = await categoryRepo.getAll();
  if (existingCategories.isNotEmpty) return;

  // Seed Game Types (Categories)
  final consoleId = await categoryRepo.create('Console', 50.0);
  final billiardId = await categoryRepo.create('Billiard', 40.0);
  final pingPongId = await categoryRepo.create('Ping Pong', 40.0);
  final snookerId = await categoryRepo.create('Snooker', 60.0);

  // Seed Game Tables
  await tableRepo.addTable('Console 1', consoleId);
  await tableRepo.addTable('Console 2', consoleId);
  await tableRepo.addTable('Billiard 1', billiardId);
  await tableRepo.addTable('Billiard 2', billiardId);
  await tableRepo.addTable('Ping Pong 1', pingPongId);
  await tableRepo.addTable('Ping Pong 2', pingPongId);
  await tableRepo.addTable('Snooker 1', snookerId);
}
