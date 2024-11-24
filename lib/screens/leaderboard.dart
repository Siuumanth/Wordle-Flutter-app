// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/widgets/RankCard.dart';
import 'package:wordle/model/Player.dart';
import 'package:wordle/model/providers/instances.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({
    super.key,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

List<leaderBoardDetails> leaderboard = [
  leaderBoardDetails(username: 'Alice', score: 800, pfp: "5"),
  leaderBoardDetails(username: 'Bob', score: 1500, pfp: "2"),
  leaderBoardDetails(username: 'Charlie', score: 900, pfp: "6"),
  leaderBoardDetails(username: 'bruh', score: 70, pfp: "6"),
];

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<int> scoreToIndex = [];

  List<leaderBoardDetails> leaderboard = [];

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
    print(scoreToIndex);
    print("Insertion sort complete.");
  }

  Future<void> getLeaderboardLocal() async {
    leaderboard = await Instances.userRef.getLeaderBoard();
    print("Leaderboard fetched.");
  }

  Future<void> fetchAndSortLeaderboard() async {
    await getLeaderboardLocal();
    insertionSort();
    setState(() {});
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
    return Scaffold(
      appBar: buildAppBar(context, screenWidth, appBarWidth),
      body: Container(
        color: white,
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
                    color: white,
                    border: Border.all(
                      color: darkerertheme,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: buildRankBar(),
                      ),
                      Expanded(
                        flex: 25,
                        child: leaderboard.isEmpty
                            ? Center(
                                child: Text(
                                  "Loading leaderboard...",
                                  style: TextStyle(
                                      color: darkerertheme, fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                itemCount: leaderboard.length,
                                itemBuilder: (context, index) {
                                  final details =
                                      leaderboard[scoreToIndex[index]];
                                  return RankCard(
                                    details: details,
                                    rank: index + 1,
                                  );
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
    );
  }
}

Widget buildRankBar() {
  return Container(
    padding: const EdgeInsets.only(left: 15),
    decoration: BoxDecoration(
      color: darkerertheme,
      borderRadius: BorderRadius.circular(11),
    ),
    child: const Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "Rank",
            style: TextStyle(color: white, fontSize: 16),
          ),
        ),
        Expanded(
          flex: 8,
          child: Text(
            "Username",
            style: TextStyle(color: white, fontSize: 16),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            "Score",
            style: TextStyle(color: white, fontSize: 16),
          ),
        ),
      ],
    ),
  );
}

AppBar buildAppBar(
    BuildContext context, double screenWidth, double appBarWidth) {
  return AppBar(
    automaticallyImplyLeading: true, // Back button will be automatically added
    backgroundColor: white,
    elevation: 1,
    title: const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.leaderboard, color: Colors.amber, size: 23),
        SizedBox(width: 8),
        Text(
          "Leaderboard",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: darkerertheme,
          ),
        ),
      ],
    ),
  );
}
