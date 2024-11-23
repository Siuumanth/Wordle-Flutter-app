// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/model/Player.dart';

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
  Color checkColor() {
    if (widget.rank > 3) {
      return const Color.fromARGB(255, 237, 237, 237);
    }
    switch (widget.rank) {
      case 1:
        return goldRank;
      case 2:
        return silverRank;
      case 3:
        return bronzeRank;
      default:
        return const Color.fromARGB(255, 237, 237, 237);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: checkColor(),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: lightgrey,
            spreadRadius: 2,
            blurRadius: 5,
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
                style:
                    const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40),
              Container(
                padding: const EdgeInsets.all(1),
                width: screenWidth / 17 * 2,
                height: screenWidth / 17 * 2,
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
                color: Color.fromARGB(255, 77, 77, 77),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
