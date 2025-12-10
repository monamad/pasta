import 'package:flutter/material.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.all(6.0),
          child: Icon(
            Icons.videogame_asset_rounded,
            color: AppColors.white,
            size: 22,
          ),
        ),
      ),
      title: Text('Pasta Dashboard', style: AppTextStyles.bold18),
      centerTitle: false,
      actions: [
        Container(
          padding: EdgeInsets.all(12),
          color: AppColors.greenSoft,
          child: Icon(Icons.notifications_none),
        ),
        SizedBox(width: 18),
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: Container(
            padding: EdgeInsets.all(12),
            color: AppColors.greenSoft,
            child: Icon(Icons.settings),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
