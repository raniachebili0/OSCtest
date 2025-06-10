import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_strings.dart';
import '../theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/marvel_character_card.dart';
import 'DetailsScreen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<FavoritesProvider>().loadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.marvelBlue,
      appBar: AppBar(
        backgroundColor: AppColors.marvelBlue,
        elevation: 2,
        title: Text(
          'Marvel Favorites',
          style: TextStyle(
            color: AppColors.marvelRed,
            fontFamily: 'Anton',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.marvelRed,
              ),
            );
          }

          if (provider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64.sp,
                    color: AppColors.marvelRed.withOpacity(0.5),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppColors.marvelWhite,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Add characters to your favorites',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.marvelWhite.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadFavorites(),
            color: AppColors.marvelRed,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final character = provider.favorites[index];
                if (character == null) return const SizedBox.shrink();
                
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
          );
        },
      ),
    );
  }
}
