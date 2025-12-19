import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pasta/core/routing/routes.dart';
import 'package:pasta/core/theme/app_colors.dart';
import 'package:pasta/core/theme/app_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.all(Radius.circular(8.r)),
          ),
          padding: EdgeInsets.all(6.w),
          child: Icon(
            Icons.videogame_asset_rounded,
            color: AppColors.white,
            size: 22.sp,
          ),
        ),
      ),
      title: Text('Pasta Dashboard', style: AppTextStyles.bold18),
      centerTitle: false,
      actions: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, Routes.notifications),
          child: Container(
            padding: EdgeInsets.all(12.w),
            color: isDarkMode ? AppColors.greenDark : AppColors.greenSoft,
            child: Icon(Icons.notifications_none),
          ),
        ),
        SizedBox(width: 18.w),
        Padding(
          padding: EdgeInsets.only(right: 18.w),
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.settings),
            child: Container(
              padding: EdgeInsets.all(12.w),
              color: isDarkMode ? AppColors.greenDark : AppColors.greenSoft,
              child: Icon(Icons.settings),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
