import 'package:flutter/material.dart';
import 'package:pasta/app_feature/data/repos/category_repository.dart';
import 'package:pasta/app_feature/data/repos/table_repository.dart';
import 'package:pasta/core/di/service_locator.dart';
import 'package:pasta/core/routing/app_router.dart';
import 'package:pasta/core/routing/routes.dart';
import 'package:pasta/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  await _seedData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: Routes.home,
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
