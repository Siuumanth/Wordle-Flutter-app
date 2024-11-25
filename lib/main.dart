import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wordle/wrapper.dart';
import 'package:wordle/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:wordle/model/providers/dailyProvider.dart';
import 'package:wordle/model/providers/userInfoProvider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        ChangeNotifierProvider(create: (context) => UserDetailsProvider())
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: '/',
        routes: {
          '/home': (context) => const HomeScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Wrapper(),
      ),
    );
  }
}
