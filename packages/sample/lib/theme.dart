import 'package:flutter/material.dart';

class AppTheme extends Theme {
  static const Color primaryColor = Color(0xFF1E1E1E);
  static const Color secondaryColor = Color(0xFF2A2A2A);
  static const Color accentColor = Color(0xFF007ACC);
  static const Color textColor = Colors.white;
  static const Color backgroundColor = Colors.black;

  const AppTheme({super.key, required super.data, required super.child});

  static ThemeData get theme {
    return ThemeData(
      primaryColor: primaryColor,
      secondaryHeaderColor: secondaryColor,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: NoTransitionsBuilder(),
          TargetPlatform.iOS: NoTransitionsBuilder(),
          TargetPlatform.macOS: NoTransitionsBuilder(),
          TargetPlatform.linux: NoTransitionsBuilder(),
          TargetPlatform.windows: NoTransitionsBuilder(),
          TargetPlatform.fuchsia: NoTransitionsBuilder(),
        },
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: const Color.fromARGB(255, 253, 5, 5)),
        titleMedium: TextStyle(color: textColor),
        labelMedium: TextStyle(color: textColor),
        labelSmall: TextStyle(color: textColor),
      ),
      scaffoldBackgroundColor: backgroundColor,
    );
  }
}

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
