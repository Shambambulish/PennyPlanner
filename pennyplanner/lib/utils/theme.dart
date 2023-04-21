import 'package:flutter/material.dart';

class PPColors extends ThemeExtension<PPColors> {
  PPColors(
      {required this.isDarkMode,
      required this.primaryTextColor,
      required this.secondaryTextColor,
      this.danger,
      this.progressBarColor});

  final bool isDarkMode;
  final Color? primaryTextColor;
  final Color? secondaryTextColor;
  Color? progressBarColor = Colors.green;
  Color? danger = Colors.red;

  @override
  ThemeExtension<PPColors> copyWith(
      {bool? isDarkMode,
      Color? primaryTextColor,
      Color? secondaryTextColor,
      Color? progressBarColor,
      Color? danger}) {
    return PPColors(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      progressBarColor: progressBarColor ?? this.progressBarColor,
      danger: danger ?? this.danger,
    );
  }

  @override
  ThemeExtension<PPColors> lerp(
      covariant ThemeExtension<PPColors> other, double t) {
    if (other is! PPColors) {
      return this;
    }
    return PPColors(
        isDarkMode: isDarkMode,
        primaryTextColor:
            Color.lerp(primaryTextColor, other.primaryTextColor, t),
        secondaryTextColor:
            Color.lerp(secondaryTextColor, other.secondaryTextColor, t),
        progressBarColor:
            Color.lerp(progressBarColor, other.progressBarColor, t),
        danger: Color.lerp(danger, other.danger, t));
  }
}

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;

  ThemeData light = ThemeData.light().copyWith(
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xffAF6363),
          onPrimary: Colors.white,
          secondary: const Color(0xffFFE381),
          onSecondary: ThemeData.light().colorScheme.onSecondary,
          error: ThemeData.light().colorScheme.error,
          onError: ThemeData.light().colorScheme.onError,
          background: ThemeData.light().colorScheme.background,
          onBackground: ThemeData.light().colorScheme.onBackground,
          surface: ThemeData.light().colorScheme.surface,
          onSurface: ThemeData.light().colorScheme.onSurface),
      extensions: <ThemeExtension<dynamic>>[
        PPColors(
            isDarkMode: false,
            primaryTextColor: const Color(0xff0F5B2E),
            secondaryTextColor: Colors.black)
      ]);
  ThemeData dark = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: const Color(0xffFFE381),
          onPrimary: Colors.black,
          secondary: const Color(0xffAF6363),
          onSecondary: ThemeData.dark().colorScheme.onSecondary,
          error: ThemeData.dark().colorScheme.error,
          onError: ThemeData.dark().colorScheme.onError,
          background: ThemeData.dark().colorScheme.background,
          onBackground: ThemeData.dark().colorScheme.onBackground,
          surface: ThemeData.dark().colorScheme.surface,
          onSurface: ThemeData.dark().colorScheme.onSurface),
      extensions: <ThemeExtension<dynamic>>[
        PPColors(
            isDarkMode: true,
            primaryTextColor: const Color(0xffFFE381),
            secondaryTextColor: Colors.white)
      ]);

  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  ThemeData get getTheme => _selectedTheme;
}
