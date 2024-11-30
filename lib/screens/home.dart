//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
import 'package:wordle/screens/gamescreen.dart';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wordle/screens/login/Login.dart';
//import 'package:wordle/screens/keytest.dart';
import 'package:wordle/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordle/screens/leaderboard.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:wordle/model/providers/dailyProvider.dart';
import 'package:wordle/model/providers/userInfoProvider.dart';
import 'package:provider/provider.dart';
import 'package:wordle/util/widgets/ShowNoti.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:wordle/constants/theme.dart';
//import 'package:wordle/model/providers/userInfoProvider.dart';
import 'package:wordle/util/widgets/Welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

int imagePickedHome = 0;
Color dailyColor = dailyGreen;

int completed = 0;

//  function starts the game and generates a random word for the game screen.
Future<void> startMadu(context, {bool isChallenge = false}) async {
  String contentsF = await rootBundle.loadString("assets/filtered-words.txt");
  List<String> fwords = contentsF.split('\n');
  var random = Random();
  String finalWord =
      fwords[random.nextInt(fwords.length)].substring(0, 5).toUpperCase();
  print(finalWord);

  await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => gameScreen(
            word: finalWord,
            isChallenge: isChallenge,
            restart: () => startMadu(context, isChallenge: isChallenge),
          )));
}

// Placeholder for popping back from the game screen.
void popMadu(context) {
  return;
}

class _HomeScreenState extends State<HomeScreen> {
  bool online = false;
  bool isLoading = true;
  Color buttonColor = greyLessO;
  User? user = FirebaseAuth.instance.currentUser;
  // Checks internet connectivity and verifies if the internet is available.

  Future<bool> isInternetAvailable() async {
    try {
      print("started checking for connection");
      final connectivityResult = await Connectivity().checkConnectivity();
      print(connectivityResult);
      if (connectivityResult[0] == ConnectivityResult.none) {
        print("no connection ter");
        return false;
      }
      // If there's a network, check if we can reach the internet
      print("Started pinging");
      final result = await http.get(Uri.parse('https://www.google.com'));
      print("Ended pinging");
      if (result.statusCode == 200) {
        print("Returned code 200");
        return true; // Internet is available
      }
    } catch (e) {
      print('Error checking internet availability: $e');
      return false;
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _checkFirstTime();
    if (user != null) {
      refreshDaily();
      setState(() {});
    } else {
      print("User is null");
      return;
    }
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final firstTime = prefs.getBool('firstTimePlaying') ?? true;

    if (firstTime) {
      showWelcomeDialog(context);
      prefs.setBool('firstTimePlaying', false);
    }
  }

  // Initialize data and fetch daily challenges.
  Future<void> _initializeData() async {
    if (await isInternetAvailable() == true) {
      try {
        if (mounted) {
          await Provider.of<DailyProvider>(context, listen: false)
              .getDailyChallenges();
          print("Daily challenges got 2");
          await Provider.of<UserDetailsProvider>(context, listen: false)
              .getUserDetails();
          print("User details got");
          setState(() {
            online = true;
            isLoading = false;
            buttonColor = darkertheme;
          });
        } else {
          print("The widget is not mounted");
          return;
        }
      } catch (e) {
        print("Error during initialization: $e");
      }
    } else {
      setState(() {
        print("User is foffline");
        isLoading = false;
        online = false;
        buttonColor = greyLessO;
      });
    }
  }

  Future<void> refreshDaily() async {
    print("Refreshing and updating");
    await Instances.userTracker.updateEveryday();
    await _initializeData();
  }

  Future<void> onRefreshed() async {
    if (user != null) {
      await refreshDaily();
      await Provider.of<DailyProvider>(context, listen: false)
          .getDailyChallenges();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    return Consumer<DailyProvider>(
        builder: (context, dailyProvider, child) => Consumer<
                UserDetailsProvider>(
            builder: (context, userProvider, child) => Scaffold(
                  appBar: buildAppBar(
                      context,
                      user == null
                          ? "0"
                          : userProvider.check == 1
                              ? userProvider.userDetails!.pfp.toString()
                              : "0",
                      screenWidth),
                  body: RefreshIndicator(
                    onRefresh: onRefreshed,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: screenHeight - appBarHeight - statusBarHeight,
                        child: Stack(
                          children: [
                            buildFAB(context),
                            Align(
                              alignment: Alignment.center,
                              child:
                                  Container(child: buildStartButton(context)),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: screenHeight / 15,
                                margin: const EdgeInsets.only(bottom: 20),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (user == null) {
                                      showTopMessage(
                                          context,
                                          "You need to be Signed in to access Daily Challenges",
                                          darktheme,
                                          white);
                                      return;
                                    }
                                    if (online == false) {
                                      print("bros offline");
                                      showTopMessage(context, "You're offline",
                                          darktheme, white);
                                      return;
                                    }
                                    if (user == null) {
                                      showTopMessage(
                                          context,
                                          "You need to be Signed in to access daily challenges",
                                          darkertheme,
                                          white);
                                      return;
                                    }

                                    await _initializeData();
                                    if (dailyProvider.completed < 3 &&
                                        online == true) {
                                      await dailyProvider.incrementDaily();
                                      startMadu(context, isChallenge: true);
                                    } else if (dailyProvider.completed == 3) {
                                      showTopMessage(
                                          context,
                                          "You've reached your daily challenge limit,it resets at 5:30 am daily.",
                                          darkertheme,
                                          white);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          dailyProvider.completed >= 3
                                              ? theme
                                              : theme,
                                      foregroundColor: grey,
                                      fixedSize: Size(
                                          screenWidth / 1.4, screenHeight / 18),
                                      textStyle: TextStyle(
                                        fontSize: user == null
                                            ? screenHeight / 36
                                            : screenHeight / 41,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  child: user != null
                                      ? (dailyProvider.completed != 5
                                          ? Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: Text(
                                                      user == null
                                                          ? "Daily Challenges"
                                                          : "Daily Challenges ${dailyProvider.completed}/3",
                                                    ),
                                                  ),
                                                ),
                                                user == null
                                                    ? const SizedBox()
                                                    : dailyProvider.completed >=
                                                            3
                                                        ? const Icon(
                                                            Icons.check,
                                                          )
                                                        : const Icon(
                                                            Icons.flag),
                                              ],
                                            )
                                          : (isLoading == true
                                              ? const CircularProgressIndicator(
                                                  color: grey,
                                                )
                                              : const Text("Daily Challenges")))
                                      : const Text("Daily challenges"),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  drawer: Drawer(
                    child: ListView(
                      children: [
                        DrawerHeader(
                          decoration: const BoxDecoration(color: theme),
                          child: Center(
                            child: Text(
                              "Settings",
                              style: TextStyle(
                                fontSize: screenWidth / 13,
                                color: darkModedark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.dark_mode,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                          title: const Text('Toggle Dark Mode'),
                          onTap: () {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme();

                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                )));
  }

  //
  //
  //
  AppBar buildAppBar(context, imagePicked, double screenWidth) {
    final user = FirebaseAuth.instance.currentUser;
    double appBarHeight = AppBar().preferredSize.height;
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(
            Icons.settings,
            size: appBarHeight / 1.8,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      iconTheme: const IconThemeData(color: grey),
      backgroundColor: theme,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          Text(
            'WORDLE  ',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: grey,
                fontSize: screenWidth / 14),
          ),
          const Spacer(),
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
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

Widget buildStartButton(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 170,
          width: 170,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme, foregroundColor: grey),
              onPressed: () {
                startMadu(context, isChallenge: false);
              },
              child: const Center(
                child: Text(
                  "START",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                ),
              )),
        ),
        const SizedBox(
          height: 40,
        )
      ],
    ),
  );
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
  final user = FirebaseAuth.instance.currentUser;
  return AppBar(
    backgroundColor: theme,
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
          onTap: () async {
            showTopMessage(context, "You have pressed", Colors.blue, white);
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
