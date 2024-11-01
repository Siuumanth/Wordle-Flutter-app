import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
//import 'package:wordle/screens/home.dart';

class gameScreen extends StatefulWidget {
  const gameScreen({super.key});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = screenWidth / 6;

    return Scaffold(
      appBar: gameAppBar(context),
      body: Column(
        children: [gameBox(boxWidth)],
      ),
    );
  }
}

Widget gameBox(width) {
  return Container(
    height: width,
    width: width,
    decoration: BoxDecoration(
        border: Border.all(width: 2, color: black),
        borderRadius: BorderRadius.circular(10)),
  );
}

AppBar gameAppBar(context) {
  return AppBar(
    backgroundColor: theme,
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(""),
      const Text(
        'WORDLE  ',
        style:
            TextStyle(fontWeight: FontWeight.w600, color: black, fontSize: 24),
      ),
      Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            child: const Icon(
              Icons.help_outline,
              color: black,
              size: 30,
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
              showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        insetPadding: const EdgeInsets.all(10),
                        backgroundColor: Colors.transparent,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                'assets/images/mepic.jpg',
                                // Replace with your image path
                                fit: BoxFit.cover,
                              ),
                            )));
                  });
            },
          ))
    ]),
  );
}
