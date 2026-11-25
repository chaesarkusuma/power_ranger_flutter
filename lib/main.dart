import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'utils/ranger_style.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RangerArchiveApp());
}

class RangerArchiveApp extends StatelessWidget {
  const RangerArchiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Power Rangers',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.card,
        dividerColor: AppColors.border,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryText,
          onPrimary: AppColors.card,
          secondary: AppColors.starOrange,
          onSecondary: AppColors.card,
          surface: AppColors.card,
          onSurface: AppColors.primaryText,
          outline: AppColors.border,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: AppColors.card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.border),
          ),
          textStyle: const TextStyle(color: AppColors.primaryText),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.primaryText,
          contentTextStyle: const TextStyle(color: AppColors.card),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.card,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
