// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
import 'package:wordle/util/RankCard.dart';
import 'package:wordle/model/Player.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:wordle/model/providers/userInfoProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({
    super.key,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}
/*
List<leaderBoardDetails> leaderboard = [
  leaderBoardDetails(username: 'Alice', score: 800, pfp: "5"),
  leaderBoardDetails(username: 'Bob', score: 1500, pfp: "2"),
  leaderBoardDetails(username: 'Charlie', score: 900, pfp: "6"),
  leaderBoardDetails(username: 'bruh', score: 70, pfp: "6"),
];*/

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<int> scoreToIndex = [];

  List<leaderBoardDetails> leaderboard = [];
  final user = FirebaseAuth.instance.currentUser;
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
    // print(scoreToIndex);
  }

////
  Future<void> getLeaderboardLocal() async {
    leaderboard = await Instances.userRef.getLeaderBoard();
    print("Leaderboard fetched.");
  }

  Future<void> fetchAndSortLeaderboard() async {
    await getLeaderboardLocal();
    print("Leaderboard got");
    insertionSort();
    print("Insertion sort done");
    setState(() {});
  }

  Future<void> saveUserRank(int rank) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userRank', rank);
    print("User rank saved: $rank");
  }

  @override
  void initState() {
    super.initState();
    print("Initializing Leaderboard Screen...");
    fetchAndSortLeaderboard();
  }

  @override
  Widget build(BuildContext context) {
    double appBarWidth = AppBar().preferredSize.width;
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<UserDetailsProvider>(
      builder: (context, userProvider, child) => RefreshIndicator(
        onRefresh: () async {
          await fetchAndSortLeaderboard();
        },
        child: Scaffold(
          appBar: buildAppBar(context, screenWidth, appBarWidth),
          body: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 9,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        /*    border: Border.all(
                          color: Theme.of(context).unselectedWidgetColor,
                          width: 3,
                        ),*/
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: buildRankBar(context),
                          ),
                          Expanded(
                            flex: 25,
                            child: leaderboard.isEmpty
                                ? Center(
                                    child: Text(
                                      "Loading leaderboard...",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color,
                                          fontSize: 20),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: leaderboard.length,
                                    itemBuilder: (context, index) {
                                      final details =
                                          leaderboard[scoreToIndex[index]];
                                      if (user != null) {
                                        if (details.username ==
                                            userProvider
                                                .userDetails!.username) {
                                          saveUserRank(index + 1);
                                          print(
                                              "User saved ${(index + 1).toString()}");
                                        }
                                        return RankCard(
                                            details: details,
                                            rank: index + 1,
                                            isUser: details.username ==
                                                userProvider
                                                    .userDetails!.username);
                                      } else {
                                        return RankCard(
                                            details: details,
                                            rank: index + 1,
                                            isUser: false);
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildRankBar(BuildContext context) {
  Color? textColor =
      Theme.of(context).brightness == Brightness.light ? white : darkModebg;
  FontWeight wt = FontWeight.w500;
  return Container(
    padding: const EdgeInsets.only(left: 15),
    decoration: BoxDecoration(
      color: Theme.of(context).unselectedWidgetColor,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: [
        Expanded(
          flex: 6,
          child: Text(
            "Rank",
            style: TextStyle(color: textColor, fontSize: 16, fontWeight: wt),
          ),
        ),
        Expanded(
          flex: 12,
          child: Text(
            "User",
            style: TextStyle(color: textColor, fontSize: 16, fontWeight: wt),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            "Score",
            style: TextStyle(color: textColor, fontSize: 16, fontWeight: wt),
          ),
        ),
      ],
    ),
  );
}

AppBar buildAppBar(
    BuildContext context, double screenWidth, double appBarWidth) {
  return AppBar(
    automaticallyImplyLeading: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    iconTheme: Theme.of(context).iconTheme,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.leaderboard, color: Colors.amber, size: 23),
        SizedBox(width: 8),
        Text(
          "Leaderboard",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).unselectedWidgetColor,
          ),
        ),
        SizedBox(
          width: screenWidth / 6,
        )
      ],
    ),
  );
}
