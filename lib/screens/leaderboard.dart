import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/widgets/RankCard.dart';
import 'package:wordle/model/Player.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

List<Player> leaderboard = [
  Player(rank: 1, username: 'Alice', score: 1200),
  Player(rank: 2, username: 'Bob', score: 1100),
  Player(rank: 3, username: 'Charlie', score: 1050),
];

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Expanded(
                  flex: 6,
                  child: Container(
                    decoration: const BoxDecoration(color: white),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: theme,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: theme,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: theme,
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  )),
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
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: buildRankBar(),
                        ),
                        Expanded(
                          flex: 12,
                          child: ListView.builder(
                            itemCount: leaderboard.length,
                            itemBuilder: (context, index) {
                              final player = leaderboard[index];
                              return RankCard(
                                rank: player.rank,
                                username: player.username,
                                score: player.score,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ))
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
      borderRadius: BorderRadius.circular(15),
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
            child:
                Text("Username", style: TextStyle(color: white, fontSize: 16))),
        Expanded(
            flex: 3,
            child: Text("Score", style: TextStyle(color: white, fontSize: 16)))
      ],
    ),
  );
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: theme,
    title: const Text(
      "Leaderboard",
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
    ),
  );
}
