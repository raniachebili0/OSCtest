import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/marvel_character_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_strings.dart';
import 'DetailsScreen.dart';
import '../models/MarvelCharacter.dart';
import '../widgets/search_bar_widget.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: themeProvider.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        elevation: 2,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: themeProvider.isDarkMode ? AppColors.darkText : AppColors.lightText,
            fontFamily: 'Anton',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: themeProvider.isDarkMode ? AppColors.darkText : AppColors.lightText,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            hintText: 'Search favorites...',
            searchQuery: favoritesProvider.searchQuery,
            onChanged: (value) => favoritesProvider.setSearchQuery(value),
            onClear: () => favoritesProvider.setSearchQuery(''),
          ),
          Expanded(
            child: favoritesProvider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.marvelRed,
                    ),
                  )
                : favoritesProvider.favorites.isEmpty
                    ? Center(
                        child: Text(
                          AppStrings.noFavorites,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: themeProvider.isDarkMode ? AppColors.darkSecondaryText : AppColors.lightSecondaryText,
                          ),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => favoritesProvider.loadFavorites(),
                        color: AppColors.marvelRed,
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          itemCount: favoritesProvider.favorites.length,
                          itemBuilder: (context, index) {
                            final character = favoritesProvider.favorites[index];
                            return MarvelCharacterCard(
                              character: character,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailsScreen(character: character),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
