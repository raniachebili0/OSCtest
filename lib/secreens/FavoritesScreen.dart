import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
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
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider()..loadFavorites(),
      child: Consumer<FavoritesProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.marvelBlue,
            appBar: AppBar(
              backgroundColor: AppColors.marvelBlue,
              elevation: 2,
              title: Text(
                'Favorites',
                style: TextStyle(
                  color: AppColors.marvelRed,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                SearchBarWidget(
                  hintText: 'Search favorites...',
                  searchQuery: provider.searchQuery,
                  onChanged: provider.updateSearchQuery,
                  onClear: () => provider.updateSearchQuery(''),
                ),
                Expanded(
                  child: provider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.marvelRed,
                          ),
                        )
                      : provider.favorites.isEmpty
                          ? Center(
                              child: Text(
                                AppStrings.noFavorites,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: AppColors.marvelGrey,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () => provider.loadFavorites(),
                              color: AppColors.marvelRed,
                              child: ListView.builder(
                                padding: EdgeInsets.symmetric(vertical: 8.h),
                                itemCount: provider.favorites.length,
                                itemBuilder: (context, index) {
                                  final character = provider.favorites[index];
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
        },
      ),
    );
  }
}
