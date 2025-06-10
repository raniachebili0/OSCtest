import 'package:flutter/material.dart';
import '../theme/app_strings.dart';
import '../theme/app_colors.dart';


class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.marvelWhite,
      child: const Center(
        child: Text(
          AppStrings.favoritesScreenTitle,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.marvelRed,
          ),
        ),
      ),
    );
  }
}
