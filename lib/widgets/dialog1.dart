import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';

class WinnerBox extends StatelessWidget {
  const WinnerBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // This ensures the dialog only takes as much space as it needs
          children: [
            const SizedBox(
              height: 10,
            ),
            const Expanded(
              child: Text(
                "CONGRATULATIONS",
                style: TextStyle(
                    color: gold, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(child: Image.asset('assets/images/winner.png')),
            Container(
              height: 50,
              color: theme,
            )
          ],
        ),
      ),
    );
  }
}
