import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/app_feature/data/data_base/app_database.dart';
import 'package:pasta/app_feature/logic/home/home_cubit.dart';
import 'package:pasta/core/routing/routes.dart';

import 'package:pasta/core/theme/app_style.dart';

class StartNewSessionGrid extends StatelessWidget {
  const StartNewSessionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            childAspectRatio: 1.5,
            physics: NeverScrollableScrollPhysics(),
            children: state.categories
                .map((category) => CategoryCard(category: category))
                .toList(),
          );
        }
        return Center(
          child: Text(state is HomeError ? state.message : 'Unknown error'),
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryData category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.startNewSession,
            arguments: category,
          ).then((value) async {
            if (value == true) {
              if (context.mounted) {
                context.read<HomeCubit>().loadHomeData();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${category.name} session started successfully!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            }
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getCategoryIcon(category.name),
            Text(category.name, style: AppTextStyles.regular16),
          ],
        ),
      ),
    );
  }

  Widget getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case 'Ping Pong':
        return Image.asset('assets/pingpong.png', width: 24.w, height: 24.w);
      case 'Console':
        return Image.asset('assets/console.png', width: 24.w, height: 24.w);
      case 'Billiard':
        return Image.asset('assets/billiard.png', width: 24.w, height: 24.w);
      case 'Snooker':
        return Image.asset('assets/snooker.png', width: 24.w, height: 24.w);
      default:
        return Icon(Icons.category);
    }
  }
}
