// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';

import 'package:wordle/screens/login/Login.dart';

String font = 'Georgia';

class RuleBox extends StatelessWidget {
  const RuleBox({super.key});

  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      backgroundColor: white,
      elevation: 16,
      child: Container(
        width: screenWidth / 1.2,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              "How to Play",
              style: textStyle(sH, 30, FontWeight.w800),
            ),
            const SizedBox(height: 10),
            Text(
              "Guess the Wordle in 6 tries.",
              style: textStyle(sH, 45, FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Text(
              "• Each guess must be a valid 5 letter word.\n\n• The colour of the tiles will change to show how close your guesss was to the word.",
              style: textStyle(sH, 57, FontWeight.w500),
            ),
            const SizedBox(height: 20),
            Text(
              "Examples: \n",
              style: textStyle(sH, 45, FontWeight.w500),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

TextStyle textStyle(ht, div, FontWeight wt) {
  return TextStyle(
      color: black, fontSize: ht / div, fontWeight: wt, fontFamily: font);
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
