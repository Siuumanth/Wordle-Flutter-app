import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wordle/wrapper.dart';
import 'package:wordle/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:wordle/model/providers/instances.dart';

void resetDailyTask() {}
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
        )
      ],
      child: MaterialApp(
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
