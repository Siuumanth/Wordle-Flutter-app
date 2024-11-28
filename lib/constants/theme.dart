import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: theme,
  scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
  unselectedWidgetColor: darkerertheme,
  appBarTheme: const AppBarTheme(color: theme),
  iconTheme: const IconThemeData(color: grey),
  cardColor: const Color.fromARGB(255, 246, 246, 246),
  textTheme: const TextTheme(
      bodyMedium: TextStyle(color: darkModebg),
      bodySmall: TextStyle(color: Color.fromARGB(195, 22, 22, 22)),
      bodyLarge: TextStyle(color: darkModebg),
      titleSmall: TextStyle(color: cardBlue),
      displayLarge:
          TextStyle(color: Color.fromARGB(255, 28, 28, 28)), //boxborder
      displayMedium: TextStyle(color: Color(0xff444242)), //boxText
      displaySmall: TextStyle(color: kbgrey)),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: theme,
  scaffoldBackgroundColor: const Color.fromARGB(232, 34, 34, 34),
  appBarTheme: const AppBarTheme(color: theme),
  cardColor: const Color.fromARGB(195, 42, 42, 42),
  iconTheme: const IconThemeData(color: white),
  unselectedWidgetColor: theme,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: white),
    bodySmall: TextStyle(color: white),
    bodyLarge: TextStyle(color: white),
    titleLarge: TextStyle(color: white),
    titleSmall: TextStyle(color: cardBlue),
    displayLarge: TextStyle(color: Color.fromARGB(255, 104, 104, 104)),
    displaySmall: TextStyle(color: Color.fromARGB(255, 129, 129, 129)),
  ),
);

//import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    await prefs.setBool('isDarkMode', _themeMode == ThemeMode.dark);

    notifyListeners();
  }
}
