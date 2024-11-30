import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wordle/wrapper.dart';
import 'package:wordle/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:wordle/model/providers/dailyProvider.dart';
import 'package:wordle/model/providers/userInfoProvider.dart';
import 'constants/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  print("runnning my app");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    //regisering providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Instances(),
        ),
        ChangeNotifierProvider(create: (context) => DailyProvider()),
        ChangeNotifierProvider(create: (context) => UserDetailsProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          navigatorKey: navigatorKey,
          themeMode: themeProvider.themeMode,
          initialRoute: '/',
          routes: {
            '/home': (context) => const HomeScreen(),
          },
          debugShowCheckedModeBanner: false,
          title: 'Wordle',
          home: const Wrapper(),
        ),
      ),
    );
  }
}
