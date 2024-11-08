import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';

import 'package:wordle/screens/login/Login.dart';

class WinnerBox extends StatelessWidget {
  final String word;
  final restart;
  final popmethod;
  const WinnerBox(
      {required this.popmethod,
      required this.restart,
      required this.word,
      super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: dialog1,
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
                  color: gold,
                  fontSize: screenHeight / 30,
                  fontWeight: FontWeight.w900),
            ),
            Image.asset(
              'assets/images/winner.png',
              height: screenHeight * 0.3,
              fit: BoxFit.contain,
            ),
            Text(
              "The word was ${word}",
              style: TextStyle(
                color: white,
                fontSize: screenHeight / 40,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: screenWidth / 2.3,
              child: dialogButton(
                  "Play Another", screenHeight, screenWidth, restart, context),
            ),
            const SizedBox(height: 20),
            Container(
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
    String text, double ht, double width, action, BuildContext context) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 221, 25),
        foregroundColor: dialog1),
    onPressed: () async {
      if (text == "Play Another") {
        Navigator.pop(context);
        Navigator.pop(context);

        print("Popped the screen");
      }

      await action(context);
    },
    child: Text(
      text,
      style: TextStyle(fontSize: ht / 47, fontWeight: FontWeight.w600),
    ),
  );
}
