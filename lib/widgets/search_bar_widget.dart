import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final String searchQuery;
  final Function(String) onChanged;
  final VoidCallback onClear;

  const SearchBarWidget({
    Key? key,
    required this.hintText,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      child: TextField(
        onChanged: onChanged,
        controller: TextEditingController(text: searchQuery),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.marvelGrey.withOpacity(0.7),
            fontSize: 14.sp,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.marvelRed,
            size: 20.w,
          ),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppColors.marvelGrey,
                    size: 20.w,
                  ),
                  onPressed: onClear,
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }
} 