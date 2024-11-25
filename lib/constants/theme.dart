import 'package:flutter/material.dart';
import 'constants.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: theme,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(color: theme),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: theme,
  scaffoldBackgroundColor: darkModebg,
  appBarTheme: const AppBarTheme(color: theme),
  textTheme: const TextTheme(
      bodyMedium: TextStyle(color: white),
      bodySmall: TextStyle(color: white),
      bodyLarge: TextStyle(color: white),
      titleLarge: TextStyle(color: white),
      displaySmall: TextStyle(color: black)),
);

//
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode =
        themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
