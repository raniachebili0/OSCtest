import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_strings.dart';
import 'package:provider/provider.dart';
import '../providers/details_screen_provider.dart';
import '../widgets/comic_card.dart';
import '../models/MarvelCharacter.dart';

class DetailsScreen extends StatelessWidget {
  final MarvelCharacter character;
  const DetailsScreen({Key? key, required this.character}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailsScreenProvider(character),
      child: Consumer<DetailsScreenProvider>(
        builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: AppColors.marvelBlue,
            appBar: AppBar(
              backgroundColor: AppColors.marvelBlue,
              elevation: 2,
              title: Text(
                'Marvel Details',
                style: TextStyle(
                  color: AppColors.marvelRed,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              centerTitle: true,
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
                            color: AppColors.marvelRed,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          provider.description,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.marvelGrey,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Comics',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.marvelRed,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        if (provider.isLoadingComics)
                          const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.marvelRed,
                            ),
                          )
                        else if (provider.comicsError != null)
                          Center(
                            child: Text(
                              provider.comicsError!,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.marvelRed,
                              ),
                            ),
                          )
                        else if (provider.comics.isEmpty)
                          Center(
                            child: Text(
                              'No comics found',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.marvelGrey,
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
