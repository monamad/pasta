import 'package:flutter/material.dart';
import 'package:pasta/core/theme/app_colors.dart';

class DecoratedCategoryIcon extends StatelessWidget {
  final DecoratedCategoryIconData data;
  const DecoratedCategoryIcon({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: data.iconBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Icon(data.icon, color: data.iconColor, size: 24),
    );
  }
}

class DecoratedCategoryIconData {
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;

  DecoratedCategoryIconData({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
  });
}

Map<String, DecoratedCategoryIconData> categoryIcons = {
  "Console": DecoratedCategoryIconData(
    icon: Icons.videogame_asset_rounded,
    iconColor: Colors.purple,
    iconBackgroundColor: AppColors.lilac,
  ),
  "Ping Pong": DecoratedCategoryIconData(
    icon: Icons.videogame_asset_rounded,
    iconColor: Colors.purple,
    iconBackgroundColor: AppColors.lilac,
  ),
  "Billiard": DecoratedCategoryIconData(
    icon: Icons.videogame_asset_rounded,
    iconColor: Colors.purple,
    iconBackgroundColor: AppColors.lilac,
  ),
  "Snooker": DecoratedCategoryIconData(
    icon: Icons.videogame_asset_rounded,
    iconColor: Colors.purple,
    iconBackgroundColor: AppColors.lilac,
  ),
};
