// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/model/Player.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RankCard extends StatefulWidget {
  final leaderBoardDetails details;
  final int rank;

  const RankCard({super.key, required this.details, required this.rank});

  @override
  State<RankCard> createState() => _RankCardState();
}

class _RankCardState extends State<RankCard> {
  Color goldRank = const Color.fromARGB(172, 252, 233, 26);
  Color silverRank = const Color.fromARGB(148, 202, 202, 202);
  Color bronzeRank = const Color.fromARGB(123, 255, 170, 155);
  final user = FirebaseAuth.instance.currentUser;
  LinearGradient checkColor() {
    // If rank is greater than 3, use the default gradient
    if (widget.rank > 3) {
      return const LinearGradient(
        colors: [Colors.white, Color.fromARGB(255, 237, 237, 237)],
      );
    }

    switch (widget.rank) {
      case 1:
        return LinearGradient(
          colors: [
            const Color.fromARGB(220, 253, 216, 53),
            Colors.yellow.shade100
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 2:
        return LinearGradient(
          colors: [
            const Color.fromARGB(255, 183, 183, 183),
            Colors.grey.shade300
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 3:
        return const LinearGradient(
          colors: [
            Color.fromARGB(255, 255, 166, 57),
            Color.fromARGB(223, 255, 209, 140)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [lightgrey, lightgrey],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient: checkColor(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: lightgrey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "${widget.rank}",
                style: TextStyle(
                    fontSize: screenWidth / 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40),
              Container(
                padding: const EdgeInsets.all(1),
                width: screenWidth / 20 * 2,
                height: screenWidth / 20 * 2,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 58, 58, 58),
                ),
                child: CircleAvatar(
                  radius: screenWidth / 17 - 20,
                  child: ClipOval(
                    child: Image.asset(
                      "assets/profiles/${widget.details.pfp}.png",
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                widget.details.username,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            ' ${widget.details.score}',
            style: const TextStyle(
                color: Color.fromARGB(255, 24, 24, 24),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
