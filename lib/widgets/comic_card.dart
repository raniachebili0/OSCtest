import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class ComicCard extends StatelessWidget {
  final Map<String, dynamic> comic;

  const ComicCard({
    Key? key,
    required this.comic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final thumbnail = comic['thumbnail'] as Map<String, dynamic>;
    final imageUrl = '${thumbnail['path']}.${thumbnail['extension']}';
    final title = comic['title'] as String;
    final issueNumber = comic['issueNumber']?.toString() ?? 'N/A';
    final date = comic['dates']?.firstWhere(
          (date) => date['type'] == 'onsaleDate',
          orElse: () => {'date': 'N/A'},
        )['date'] as String? ?? 'N/A';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              width: 100.w,
              height: 150.h,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100.w,
                height: 150.h,
                color: AppColors.marvelGrey.withOpacity(0.1),
                child: Icon(Icons.image, size: 40.sp, color: AppColors.marvelGrey),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.marvelRed,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Issue #$issueNumber',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.marvelRed,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.marvelBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          date.split('T')[0],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.marvelBlue,
                            fontWeight: FontWeight.w500,
                          ),
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
    );
  }
} 