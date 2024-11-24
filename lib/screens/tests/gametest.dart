// ignore_for_file: camel_case_types
/*
import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';

class gameScreen extends StatefulWidget {
  final String word;
  const gameScreen({required this.word, super.key});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  List<List<dynamic>>? grid;
  int counter = 0;
  final List<GlobalKey<GameBoxState>> _gameBoxKeys =
      List.generate(30, (index) => GlobalKey<GameBoxState>());

  void change_color() {
    if (counter < _gameBoxKeys.length) {
      _gameBoxKeys[counter]
          .currentState
          ?.changeColor(); // Call changeColor on the specific box
      counter++;
      if (counter >= _gameBoxKeys.length) {
        counter = 0; // Reset counter to loop back to the start
      }
    }
  }

  @override
  void initState() {
    super.initState();
    grid = List.generate(6, (_) => List.filled(5, null));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double boxWidth = screenWidth / 7;

    return Scaffold(
      appBar: gameAppBar(context),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth / 42),
            child: GridView.count(
              crossAxisCount: 5,
              physics: const BouncingScrollPhysics(),
              children: List.generate(
                30,
                (index) {
                  return GameBox(
                    width: boxWidth,
                    key: _gameBoxKeys[index],
                    initialColor: Colors.white,
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20, // Position the button at the bottom
            left: (screenWidth / 2) - 50, // Center the button
            child: ElevatedButton(
              onPressed: () {
                change_color();
              },
              child: const Text("Press"),
            ),
          ),
        ],
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
  late Color boxColor;

  @override
  void initState() {
    super.initState();
    boxColor = widget.initialColor; // Use initial color from the widget
  }

  void changeColor() {
    setState(() {
      boxColor =
          boxColor == Colors.white ? Colors.cyan : Colors.white; // Toggle color
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      height: widget.width,
      width: widget.width,
      decoration: BoxDecoration(
        color: boxColor, // Use the state color
        border: Border.all(width: 1.5, color: black),
        borderRadius: BorderRadius.circular(5),
      ),
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


*/