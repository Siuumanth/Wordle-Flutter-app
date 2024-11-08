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
  Player(rank: 4, username: 'Alice', score: 1200),
  Player(rank: 5, username: 'Bob', score: 1100),
  Player(rank: 6, username: 'Charlie', score: 1050),
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: PlaceholderContainer(
                        rank: 2,
                        player: leaderboard.isNotEmpty ? leaderboard[1] : null,
                        heightFactor: 2.5,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: PlaceholderContainer(
                        rank: 1,
                        player: leaderboard.isNotEmpty ? leaderboard[0] : null,
                        heightFactor: 3.5,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: PlaceholderContainer(
                        rank: 3,
                        player: leaderboard.isNotEmpty ? leaderboard[2] : null,
                        heightFactor: 2,
                      ),
                    ),
                  ],
                ),
              ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder Container for each stage (left, middle, right)
class PlaceholderContainer extends StatelessWidget {
  final int rank;
  final Player? player;
  final double heightFactor;

  const PlaceholderContainer({
    super.key,
    required this.rank,
    this.player,
    required this.heightFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: theme.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Rank Circle (Placeholders for profile pictures)
          CircleAvatar(
            radius: 30,
            backgroundColor: theme,
            child: player != null
                ? ClipOval(
                    child: Image.network(
                      "https://www.example.com/user_profile_image.png", // Replace with actual user image URL
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.person, size: 40, color: white),
          ),
          const SizedBox(height: 8),
          // Username
          Text(
            player?.username ?? "Player $rank",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          // Score
          Text(
            "${player?.score ?? 0} Points",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
        ],
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
