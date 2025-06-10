import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_strings.dart';
import 'package:provider/provider.dart';
import '../providers/details_screen_provider.dart';

class DetailsScreen extends StatelessWidget {
  final Map<String, dynamic> character;
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
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: provider.imageUrl,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          provider.imageUrl,
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
                    SizedBox(height: 24.h),
                    Text(
                      provider.name,
                      style: TextStyle(
                        fontFamily: 'Anton',
                        fontSize: 32.sp,
                        color: AppColors.marvelRed,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      provider.description.isNotEmpty ? provider.description : AppStrings.noDescription,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.marvelWhite,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // Ajoute ici d'autres infos si besoin (comics, etc.)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
