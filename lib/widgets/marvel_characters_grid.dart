import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'marvel_character_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_strings.dart';

class MarvelCharactersGrid extends StatelessWidget {
  final List<Map<String, dynamic>> characters;
  final bool isLoading;
  final String? error;
  final Function(Map<String, dynamic>) onCharacterTap;
  final Future<void> Function() onRefresh;

  const MarvelCharactersGrid({
    Key? key,
    required this.characters,
    required this.isLoading,
    this.error,
    required this.onCharacterTap,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.marvelRed,
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: AppColors.marvelRed,
            ),
            SizedBox(height: 16.h),
            Text(
              error!,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.marvelRed,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (characters.isEmpty) {
      return Center(
        child: Text(
          AppStrings.noCharactersFound,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.marvelGrey,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.marvelRed,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final character = characters[index];
          return MarvelCharacterCard(
            character: character,
            onTap: () => onCharacterTap(character),
          );
        },
      ),
    );
  }
} 