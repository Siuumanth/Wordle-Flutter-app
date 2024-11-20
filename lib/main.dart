import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wordle/wrapper.dart';
import 'package:wordle/screens/home.dart';
import 'package:workmanager/workmanager.dart';

sendData() {
  print("HIIIIIIIIIIIII");
}

const task = 'firsttask';
void callbackDispatcher() {
  //function to be repeated
  Workmanager().executeTask((taskName, inputData) {
    switch (taskName) {
      case 'firsttask':
        sendData();
        print("First task has been executed");
        break;
    }
    return Future.value(true);
  });
}

void resetDailyTask() {}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Workmanager().initialize(callbackDispatcher,
      isInDebugMode: true); //accepts the function to be repeated
  //if true, then it shows norification when activated

//registering task, whenever our app opens
  var uniqueId = DateTime.now().second.toString();
  await Workmanager().registerPeriodicTask(uniqueId, task,
      initialDelay: const Duration(seconds: 10),
      constraints: Constraints(networkType: NetworkType.connected),
      frequency: Duration(minutes: 15, seconds: 10));
  print("The task has been initialized");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String realTimeValue = '0';
  String getOnceValue = '0';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
