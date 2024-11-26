// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
import 'package:wordle/model/Player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RankCard extends StatefulWidget {
  final leaderBoardDetails details;
  final int rank;
  final bool isUser;

  const RankCard(
      {super.key,
      required this.details,
      required this.rank,
      required this.isUser});

  @override
  State<RankCard> createState() => _RankCardState();
}

class _RankCardState extends State<RankCard> {
  final user = FirebaseAuth.instance.currentUser;

  // A helper method to style the rank differently for 1st, 2nd, and 3rd places
  Widget rankBadge(int rank, double screenWidth) {
    double rankSize = screenWidth / 17;
    double iconSize = 18;
    switch (rank) {
      case 1:
        return Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.amber, size: iconSize),
            Text(
              "1",
              style: TextStyle(
                fontSize: rankSize,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        );
      case 2:
        return Row(
          children: [
            Icon(Icons.workspace_premium,
                color: const Color.fromARGB(255, 140, 140, 140),
                size: iconSize),
            Text(
              "2",
              style: TextStyle(
                fontSize: rankSize,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 140, 140, 140),
              ),
            ),
          ],
        );
      case 3:
        return Row(
          children: [
            Icon(Icons.workspace_premium, color: Colors.brown, size: iconSize),
            Text(
              "3",
              style: TextStyle(
                fontSize: rankSize,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
          ],
        );
      default:
        return Row(
          children: [
            Icon(Icons.workspace_premium,
                color: Colors.transparent, size: iconSize),
            Text(
              "$rank",
              style: TextStyle(
                fontSize: rankSize,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double avatarSize = screenWidth / 10;

    Color? textColor = Theme.of(context).textTheme.bodyMedium!.color;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      padding: const EdgeInsets.only(left: 10, right: 16, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: !widget.isUser ? Theme.of(context).cardColor : cardBlue,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          rankBadge(widget.rank, screenWidth),
          const Expanded(flex: 2, child: SizedBox()),
          Row(
            children: [
              SizedBox(
                width: avatarSize,
                height: avatarSize,
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    "assets/profiles/${widget.details.pfp}.png",
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.details.username,
                style: TextStyle(
                  fontSize: screenWidth / 22,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
          const Expanded(flex: 4, child: SizedBox()),
          Text(
            "${widget.details.score}",
            style: TextStyle(
              fontSize: screenWidth / 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
