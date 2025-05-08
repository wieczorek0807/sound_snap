part of 'styles.dart';

abstract class AppTheme {
  static ThemeData defaultAppTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  );
}
