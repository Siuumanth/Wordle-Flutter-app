//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/screens/gamescreen.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wordle/screens/login/Login.dart';
//import 'package:wordle/screens/keytest.dart';
import 'package:wordle/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordle/screens/leaderboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/model/dbRef.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final user = FirebaseAuth.instance.currentUser;
int imagePickedHome = 0;
Color dailyColor = dailyGreen;
final _userRef = DatabaseRef();

Future<void> startMadu(context, {bool isChallenge = false}) async {
  String contentsF = await rootBundle.loadString("assets/filtered-words.txt");
  List<String> fwords = contentsF.split('\n');
  var random = Random();
  String finalWord =
      fwords[random.nextInt(fwords.length)].substring(0, 5).toUpperCase();
  print(finalWord);
  print("Is it a daily challenge ${isChallenge.toString()}");

  await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => gameScreen(
          word: finalWord,
          isChallenge: isChallenge,
          restart: () => startMadu(context, isChallenge: isChallenge),
          popmethod: () => popMadu(context))));
}

void popMadu(context) {
  return;
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> getPFP() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      imagePickedHome = prefs.getInt('imagePicked') ?? 0;
      if (imagePickedHome == 0) {
        imagePickedHome = await _userRef.getFirePfp(user!);
      }
      setState(() {
        print("Image picked is $imagePickedHome");
      });
    } catch (e) {
      print("Error retrieving profile image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getPFP();
  }

  void changeDailyColor() {
    setState(() {
      dailyColor = dailyTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: buildAppBar(context, imagePickedHome),
      body: Stack(
        children: [
          buildFAB(context),
          Align(
            alignment: Alignment.center,
            child: Container(child: buildStartButton(context)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: () {
                  startMadu(context, isChallenge: true);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: dailyGreen,
                    foregroundColor: white,
                    fixedSize: Size(screenWidth / 1.60, screenHeight / 18),
                    textStyle: TextStyle(
                        fontSize: screenHeight / 47,
                        fontWeight: FontWeight.w500)),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Daily Challenges 0/2",
                      ),
                    ),
                    Icon(Icons.flag)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStartButton(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 160,
            width: 160,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme, foregroundColor: grey),
                onPressed: () {
                  startMadu(context, isChallenge: false);
                },
                child: const Center(
                  child: Text(
                    "START",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                )),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

Widget buildFAB(context) {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, top: 20),
    child: SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        backgroundColor: darktheme,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LeaderboardScreen()));
        },
        child: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Image.asset('assets/images/trophy.png'),
        ),
      ),
    ),
  );
}

AppBar buildAppBar(context, imagePicked) {
  return AppBar(
    backgroundColor: theme,
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
          onTap: () {
            _userRef.getLeaderBoard();
          },
          child: const Icon(Icons.menu, color: grey, size: 30)),
      const Text(
        'WORDLE',
        style:
            TextStyle(fontWeight: FontWeight.w600, color: grey, fontSize: 24),
      ),
      Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            child: ClipOval(
              child: Image.asset('assets/profiles/$imagePicked.png'),
            ),
            onTap: () async {
              if (user == null) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              }
            },
          ))
    ]),
  );
}
