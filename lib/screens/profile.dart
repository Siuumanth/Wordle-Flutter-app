import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
import 'package:wordle/screens/login/Login.dart';
import 'package:wordle/screens/login/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordle/main.dart';
import 'package:wordle/model/Player.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:wordle/model/providers/userInfoProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loaded = false;
  bool rankFetched = false;
  int userRank = -1;

  final _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser;
  late profileUser? userDetails;

  List<int> scoreToIndex = [];
  List<leaderBoardDetails> leaderboard = [];

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    print("Starting to fetch profile details...");
    userDetails = await Instances.userRef.getUserDetails();
    setState(() {
      loaded = true;
    });
    print("Finished fetching profile details.");
    await fetchAndSortLeaderboard(); // load
    await getUserRank();
  }

  Future<void> profileRefresh() async {
    await fetchAndSortLeaderboard();
    await getUserRank();
    setState(() {
      rankFetched = true; // Mark the rank as fetched after refreshing
    });
  }

  Future<void> fetchAndSortLeaderboard() async {
    leaderboard = await Instances.userRef.getLeaderBoard();
    print("Leaderboard fetched.");
    insertionSort();
    print("Leaderboard sorted.");
  }

  void insertionSort() {
    List<int> scoreList =
        leaderboard.map((item) => item.score).toList().cast<int>();

    for (int i = 1; i < scoreList.length; i++) {
      int key = scoreList[i];
      int j = i - 1;

      while (j >= 0 && scoreList[j] < key) {
        scoreList[j + 1] = scoreList[j];
        j--;
      }
      scoreList[j + 1] = key;
    }

    scoreToIndex.clear();
    for (int i = 0; i < leaderboard.length; i++) {
      for (int j = 0; j < leaderboard.length; j++) {
        if (leaderboard[j].score == scoreList[i] && !scoreToIndex.contains(j)) {
          scoreToIndex.add(j);
          break;
        }
      }
    }
  }

  Future<void> saveUserRank(int rank) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userRank', rank);
    print("User rank saved: $rank");
  }

  Future<int> getUserRank() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userRank')) {
      setState(() {
        userRank = prefs.getInt('userRank')!;
        rankFetched = true; // Mark as fetched
      });
      return userRank;
    }

    for (int index = 0; index < scoreToIndex.length; index++) {
      final leader = leaderboard[scoreToIndex[index]];
      if (leader.username == userDetails!.username) {
        final rank = index + 1;
        await saveUserRank(rank);
        setState(() {
          userRank = rank;
          rankFetched = true; // Mark as fetched
        });
        return rank;
      }
    }

    setState(() {
      userRank = -1;
      rankFetched = false;
    });
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<UserDetailsProvider>(
      builder: (context, userData, child) => Scaffold(
        appBar: buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: profileRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(5),
                      width: screenWidth / 3.5 * 1.9,
                      height: screenWidth / 3.5 * 1.9,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: darkertheme,
                      ),
                      child: CircleAvatar(
                        radius: screenWidth / 17 - 20,
                        child: ClipOval(
                          child: Image.asset(
                            "assets/profiles/${userData.userDetails!.pfp}.png",
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      userData.userDetails!.username,
                      style: const TextStyle(
                          fontSize: 35, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Your rank is",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: screenWidth / 3, // Adjust size
                          height: screenWidth / 3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color!,
                              width: 4,
                            ),
                          ),
                        ),
                        !rankFetched
                            ? CircularProgressIndicator(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                              )
                            : Text(
                                "$userRank",
                                style: TextStyle(
                                  fontSize: screenWidth / 6,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Score: ${userData.userDetails!.score}",
                      style: TextStyle(
                        fontSize: screenWidth / 18,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: theme,
                          foregroundColor: darkModedark,
                          textStyle: TextStyle(
                              color: darkModedark,
                              fontSize: screenWidth / 20,
                              fontWeight: FontWeight.w700)),
                      onPressed: () async {
                        await _auth.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Container(
                          padding: const EdgeInsets.all(14),
                          child: const Text("Sign Out")),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Removes all previous routes
    );
  }

  Future<void> deleteAccount() async {
    if (user != null) {
      await user!.delete();
    }
  }
}

AppBar buildAppBar(context) {
  return AppBar(
    iconTheme: const IconThemeData(color: darkModedark),
    backgroundColor: theme,
    title: const Text(
      "Profile",
      style: TextStyle(
          fontWeight: FontWeight.w500, fontSize: 25, color: darkModedark),
    ),
  );
}
