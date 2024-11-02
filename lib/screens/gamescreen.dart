// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/widgets/keyboard.dart';

class gameScreen extends StatefulWidget {
  final String word;
  const gameScreen({required this.word, super.key});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  List<List<dynamic>>? grid;
  int counter = 0;
  final List<GlobalKey<GameBoxState>> _keys =
      List.generate(30, (index) => GlobalKey<GameBoxState>());

  @override
  void initState() {
    super.initState();
    grid = List.generate(6, (_) => List.filled(5, null));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //  double screenHeight = MediaQuery.of(context).size.height;
    double boxWidth = screenWidth / 7;
    double pad = screenWidth / 42;

    return Scaffold(
      appBar: gameAppBar(context),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        color: white,
        child: Column(
          children: [
            Expanded(
              flex: 4, // Adjust the flex to occupy more space
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: pad, vertical: pad),
                child: GridView.count(
                  crossAxisCount: 5,
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(
                    30,
                    (index) {
                      return GameBox(
                        width: boxWidth,
                        key: _keys[index],
                        initialColor: Colors.white,
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2, // Adjust the flex to control the height of the keyboard
              child: Container(
                margin: EdgeInsets.all(10),
                color: Colors.white,
                child: CustomKeyboard(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameBox extends StatefulWidget {
  final double width;
  final Color initialColor;

  const GameBox({required this.width, required this.initialColor, super.key});

  @override
  GameBoxState createState() => GameBoxState();
}

class GameBoxState extends State<GameBox> {
  Color boxColor = Colors.white;
  Color textColor = const Color(0xff444242);

  @override
  void initState() {
    super.initState();
  }

  void changeBoxColorGreen() {
    setState(() {
      boxColor = boxGreen;
    });
  }

  void changeBoxColorGrey() {
    setState(() {
      boxColor = boxGrey;
    });
  }

  void changeBoxColorYellow() {
    setState(() {
      boxColor = boxYellow;
    });
  }

  void changeTextColorWhite() {
    setState(() {
      textColor = Colors.white;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      height: widget.width,
      width: widget.width,
      decoration: BoxDecoration(
        color: boxColor,
        border: Border.all(width: 1.5, color: black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
          child: Text(
        "Z",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: widget.width / 1.1),
      )),
    );
  }
}

AppBar gameAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: theme,
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text(""),
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
                                fit: BoxFit.cover,
                              ),
                            )));
                  });
            },
          )),
    ]),
  );
}
