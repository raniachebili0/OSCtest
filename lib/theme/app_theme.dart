import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.marvelRed,
  scaffoldBackgroundColor: AppColors.marvelBlue,
  fontFamily: 'Anton',
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Anton',
      color: AppColors.marvelRed,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(
      color: AppColors.marvelWhite,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: AppColors.marvelGrey,
      fontSize: 14,
    ),
    // Ajoutez d'autres styles si besoin
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: AppColors.marvelRed,
    background: AppColors.marvelBlue,
  ),
); 