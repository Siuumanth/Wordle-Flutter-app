import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart'; // Ensure this contains the necessary color constants
//import 'package:wordle/screens/login/Login.dart';

String font = 'Poppins';

class RuleBox extends StatelessWidget {
  const RuleBox({super.key});

  @override
  Widget build(BuildContext context) {
    double sH = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    Color textColor = Theme.of(context).textTheme.titleMedium!.color!;
    //   Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Container(
      margin: EdgeInsets.zero,
      child: Dialog(
        insetPadding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color.fromARGB(217, 28, 28, 28)
            : white,
        elevation: 16,
        child: Container(
          width: screenWidth / 1.2,
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                "How to Play",
                style: textStyle(sH, 30, FontWeight.w800, textColor),
              ),
              const SizedBox(height: 20),
              // Rules explanation
              Text(
                "• You have 6 chances to guess the hidden 5-letter word. Each guess must be a word.\n\n• The color of the tiles will change to show how close your guess was to the word.",
                style: textStyle(sH, 57, FontWeight.w500, textColor),
              ),
              const SizedBox(height: 20),
              // GOL letters
              Text(
                "Examples: ",
                style: textStyle(sH, 45, FontWeight.w500, textColor),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "G",
                      style: textStyle(sH, 30, FontWeight.w700, Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: boxYellow,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "O",
                      style: textStyle(sH, 30, FontWeight.w700, white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "L",
                      style: textStyle(sH, 30, FontWeight.w700, Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Color rule explanation
              Text(
                "• If the letter is in the correct spot, it will turn green.\n\n• If the letter is in the word but in the wrong spot, it will turn yellow.\n\n• If the letter is not in the word, it will turn gray.",
                style: textStyle(sH, 57, FontWeight.w500, textColor),
              ),
              const SizedBox(height: 30),
              dialogButton("Got It", sH, screenWidth, context),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle textStyle(double ht, double div, FontWeight wt, Color textColor) {
  return TextStyle(
      color: textColor, fontSize: ht / div, fontWeight: wt, fontFamily: font);
}

Widget dialogButton(
    String text, double ht, double width, BuildContext context) {
  //Color buttonColor = Theme.of(context).buttonTheme.colorScheme!.primary;
  // Color buttonTextColor = Theme.of(context).buttonTheme.colorScheme!.onPrimary;

  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: theme,
      foregroundColor: grey,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
    child: Text(
      text,
      style: TextStyle(fontSize: ht / 47, fontWeight: FontWeight.w600),
    ),
  );
}
