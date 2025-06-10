import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:orange_test/theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

import '../theme/app_colors.dart';


class MarvelCharacterCard extends StatelessWidget {
  final Map<String, dynamic> character;
  final VoidCallback onTap;

  const MarvelCharacterCard({
    super.key,
    required this.character,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnail = character['thumbnail'] as Map<String, dynamic>;
    final imageUrl = '${thumbnail['path']}.${thumbnail['extension']}';
    final name = character['name'] as String;
    final description = character['description'] as String? ?? '';

    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, _) {
        return FutureBuilder<bool>(
          future: favoritesProvider.isFavorite(character['id']),
          builder: (context, snapshot) {
            final isFavorite = snapshot.data ?? false;
            
            return GestureDetector(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Top Section with Image and Basic Info
                    Container(
                      height: 160.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.marvelRed.withOpacity(0.1),
                            AppColors.marvelWhite,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Character Image
                          Positioned(
                            left: 16.w,
                            top: 16.h,
                            child: Container(
                              width: 120.w,
                              height: 140.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.marvelBlack.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Hero(
                                  tag: imageUrl,
                                  child:Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    height: 300.h,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      color: AppColors.marvelGrey.withOpacity(0.1),
                                      height: 300.h,
                                      child: Icon(Icons.person, size: 80.sp, color: AppColors.marvelGrey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Character Info
                          Positioned(
                            right: 16.w,
                            top: 16.h,
                            child: Container(
                              width: 200.w,
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: AppColors.marvelWhite.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.marvelBlack.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.marvelRed,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "Marvel Character",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.marvelGrey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.marvelRed.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              size: 16.w,
                                              color: AppColors.marvelRed,
                                            ),
                                            SizedBox(width: 4.w),
                                            Text(
                                              "Hero",
                                              style: TextStyle(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.marvelRed,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom Section with Additional Info
                    Container(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          // Text(
                          //   description,
                          //   style: TextStyle(
                          //     fontSize: 13.sp,
                          //     color: AppColors.marvelGrey,
                          //   ),
                          //   maxLines: 2,
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                          // SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.marvelRed.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 14.w,
                                      color: AppColors.marvelRed,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      "View Details",
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: AppColors.marvelRed,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await favoritesProvider.toggleFavorite(character);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isFavorite ? 'Removed from favorites' : 'Added to favorites',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        backgroundColor: AppColors.marvelRed,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.marvelRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        size: 14.w,
                                        color: AppColors.marvelRed,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        isFavorite ? "Remove from Favorites" : "Add to Favorites",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          color: AppColors.marvelRed,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
} 