import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_strings.dart';
import 'package:provider/provider.dart';
import '../providers/details_screen_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/comic_card.dart';
import '../models/MarvelCharacter.dart';

class DetailsScreen extends StatelessWidget {
  final MarvelCharacter character;
  const DetailsScreen({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailsScreenProvider(character),
      child: Consumer2<DetailsScreenProvider, ThemeProvider>(
        builder: (context, provider, themeProvider, _) {
          final isDarkMode = themeProvider.isDarkMode;

          return Scaffold(
            backgroundColor: isDarkMode ? AppColors.darkBackground : AppColors.lightBackground,
            appBar: AppBar(
              backgroundColor: isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
              elevation: 2,
              title: Text(
                'Marvel Details',
                style: TextStyle(
                  color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
              iconTheme: IconThemeData(
                color: isDarkMode ? AppColors.darkText : AppColors.lightText,
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                  ),
                  onPressed: () => themeProvider.toggleTheme(),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Character Image
                  Container(
                    width: double.infinity,
                    height: 300.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(provider.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Character Info
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.name,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          provider.description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: isDarkMode ? AppColors.darkText.withOpacity(0.8) : AppColors.lightText.withOpacity(0.8),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Comics',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        if (provider.isLoadingComics)
                          Center(
                            child: CircularProgressIndicator(
                              color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                            ),
                          )
                        else if (provider.comicsError != null)
                          Center(
                            child: Text(
                              provider.comicsError!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: isDarkMode ? AppColors.darkText : AppColors.lightText,
                              ),
                            ),
                          )
                        else if (provider.comics.isEmpty)
                          Center(
                            child: Text(
                              'No comics found',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: isDarkMode ? AppColors.darkText.withOpacity(0.8) : AppColors.lightText.withOpacity(0.8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.comics.length,
                            itemBuilder: (context, index) {
                              final comic = provider.comics[index];
                              return ComicCard(comic: comic);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
