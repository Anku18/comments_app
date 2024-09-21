import 'package:comments_app/config/theme/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemeData {
  AppThemeData.init();
  static final AppThemeData instance = AppThemeData.init();
  static Color primary = const Color(0xFF0C54BE);
  static Color nameCircleColor = const Color(0XFFCED3DC);
  ThemeData getLightThemeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F9FD),
      textTheme: CommentTextTheme.instance.getLightTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp)),
          maximumSize: Size(double.infinity, 55.h),
          backgroundColor: primary,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
        ),
      ),
    );
  }
}
