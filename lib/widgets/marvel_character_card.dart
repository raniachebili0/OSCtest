import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:orange_test/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../models/MarvelCharacter.dart';
import '../secreens/DetailsScreen.dart';

import '../theme/app_colors.dart';


class MarvelCharacterCard extends StatelessWidget {
  final MarvelCharacter character;
  final VoidCallback onTap;

  const MarvelCharacterCard({
    Key? key,
    required this.character,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(character.id);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(character: character),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'character_${character.id}_${character.thumbnail.path}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                    child: Image.network(
                      '${character.thumbnail.path}.${character.thumbnail.extension}',
                      height: 200.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 200.h,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: IconButton(
                    icon: Icon(
                      favoritesProvider.isFavorite(character.id) ? Icons.favorite : Icons.favorite_border,
                      color: favoritesProvider.isFavorite(character.id) ? AppColors.marvelRed : Colors.white,
                    ),
                    onPressed: () {
                      if (favoritesProvider.isFavorite(character.id)) {
                        favoritesProvider.removeFavorite(character.id);
                      } else {
                        favoritesProvider.addFavorite(character);
                      }
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    character.description.isNotEmpty
                        ? character.description
                        : 'No description available',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 