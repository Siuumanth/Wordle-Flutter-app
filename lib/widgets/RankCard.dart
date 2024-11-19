// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/model/Player.dart';

class RankCard extends StatefulWidget {
  final leaderBoardDetails details;

  const RankCard({super.key, required this.details});

  @override
  State<RankCard> createState() => _RankCardState();
}

class _RankCardState extends State<RankCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
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
                '#${widget.details.rank}',
                style:
                    const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 40),
              CircleAvatar(
                radius: screenWidth / 17,
                backgroundColor: Colors.grey[300],
                child: ClipOval(
                    child: Image.asset(
                        "assets/profiles/${widget.details.pfp}.png")),
              ),
              const SizedBox(width: 10),
              Text(
                widget.details.username,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            ' ${widget.details.score}',
            style: const TextStyle(
                color: Color.fromARGB(255, 77, 77, 77), fontSize: 20),
          ),
        ],
      ),
    );
  }
}
