import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';

import 'package:wordle/screens/login/Login.dart';

class WinnerBox extends StatefulWidget {
  final String word;
  final restart;

  const WinnerBox({required this.restart, required this.word, super.key});

  @override
  State<WinnerBox> createState() => _WinnerBoxState();
}

class _WinnerBoxState extends State<WinnerBox> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              "YOU WON!",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontSize: screenHeight / 30,
                  fontWeight: FontWeight.w900),
            ),
            Image.asset(
              'assets/images/winner.png',
              height: screenHeight * 0.3,
              fit: BoxFit.contain,
            ),
            Text(
              "The word was ${widget.word}",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontSize: screenHeight / 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: screenWidth / 2.3,
              child: dialogButton("Play Another", screenHeight, screenWidth,
                  widget.restart, context),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: screenWidth / 2.3,
              child: dialogButton(
                  "Back to Home", screenHeight, screenWidth, goToHome, context),
            )
          ],
        ),
      ),
    );
  }
}

Widget dialogButton(
    String text, double ht, double width, restart, BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 221, 25),
        foregroundColor: darkModebg),
    onPressed: () async {
      if (text == "Play Another") {
        Navigator.pop(context);
        Navigator.pop(context);

        print("Popped the screen");
      }

      await restart(context);
    },
    child: Text(
      text,
      style: TextStyle(fontSize: ht / 49, fontWeight: FontWeight.w600),
    ),
  );
}

class WinnerBoxDaily extends StatefulWidget {
  final String word;
  final restart;
  final int score;
  const WinnerBoxDaily(
      {required this.restart,
      required this.score,
      required this.word,
      super.key});

  @override
  State<WinnerBoxDaily> createState() => _WinnerBoxDailyState();
}

class _WinnerBoxDailyState extends State<WinnerBoxDaily> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text.rich(TextSpan(
              children: [
                TextSpan(
                  text: "YOU WON ",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontSize: screenHeight / 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: "${widget.score} ",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 235, 200, 0),
                    fontSize: screenHeight / 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "points!",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium!.color,
                    fontSize: screenHeight / 40,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            )),
            Image.asset(
              'assets/images/winner.png',
              height: screenHeight * 0.3,
              fit: BoxFit.contain,
            ),
            Text(
              "The word was ${widget.word}",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium!.color,
                fontSize: screenHeight / 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: screenWidth / 2.3,
              child: dialogButton(
                  "Back to Home", screenHeight, screenWidth, goToHome, context),
            )
          ],
        ),
      ),
    );
  }
}
