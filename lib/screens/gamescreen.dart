// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/widgets/keyboard.dart';

List<String> grid = List.filled(30, '');
int currentIndex = 0;
int istart = 0, istop = 5;

class gameScreen extends StatefulWidget {
  final String word;
  const gameScreen({required this.word, super.key});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  int counter = 0;
  final List<GlobalKey<GameBoxState>> _keys =
      List.generate(30, (index) => GlobalKey<GameBoxState>());

  @override
  void initState() {
    super.initState();
    grid = List.filled(30, '');
    currentIndex = 0;
    istart = 0;
    istop = 5;
  }

  void changeAlpha(String alpha) {
    setState(() {
      grid[currentIndex] = alpha;
      currentIndex++;
      print(currentIndex);
    });
  }

  void backSpace() {
    if (currentIndex == istart) {
      return;
    }

    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      }
      grid[currentIndex] = "";
    });
    print(currentIndex);
  }

  Future<void> fiveDone(String ch) async {
    if (ch == 'Enter') {
      checkTheWord();
    } else if (ch == 'Backspace') {
      backSpace();
    } else {
      return;
    }
  }

  Future<void> checkLetters(String word, alphaList) async {
    List<String> correctAlphaList = widget.word.split('');
    for (int i = 0; i < 5; i++) {
      if (alphaList[i] == correctAlphaList[i]) {
        _keys[istart + i].currentState!.changeBoxColorGreen();
      } else if (widget.word.contains(alphaList[i])) {
        _keys[istart + i].currentState!.changeBoxColorYellow();
      } else {
        _keys[istart + i].currentState!.changeBoxColorGrey();
      }
      await Future.delayed(const Duration(seconds: 0, milliseconds: 500));
    }

    if (word == widget.word) {
      showSnackBar("Congrats you won");
    } else {
      showSnackBar("Oops, try again");
      continueGame();
    }
  }

  void continueGame() {
    setState(() {
      istart += 5;
      istop += 5;
      currentIndex = istart;
    });
    print(
        "continueGame - istart: $istart, istop: $istop, currentIndex: $currentIndex");
  }

  Future<void> checkTheWord() async {
    var wordList = grid.sublist(istart, istop);
    print("Word :" + wordList.join(''));

    await checkLetters(wordList.join(''), wordList);
  }

  void showSnackBar(String snackText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          snackText,
          style: TextStyle(color: grey),
        ),
        backgroundColor: white,
        dismissDirection: DismissDirection.horizontal,
        elevation: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //  double screenHeight = MediaQuery.of(context).size.height;
    double boxWidth = screenWidth / 7;
    double pad = screenWidth / 35;

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
                          alpha: grid[index]);
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
                child: CustomKeyboard(
                  changeAlpha: changeAlpha,
                  backSpace: backSpace,
                  fiveDone: fiveDone,
                ),
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
  final String alpha;

  const GameBox({required this.width, required this.alpha, super.key});

  @override
  GameBoxState createState() => GameBoxState();
}

class GameBoxState extends State<GameBox> {
  Color boxColor = white;
  Color textColor = const Color(0xff444242);

  @override
  void initState() {
    super.initState();
  }

  void changeBoxColorGreen() {
    setState(() {
      boxColor = boxGreen;
      textColor = white;
    });
  }

  void changeBoxColorGrey() {
    setState(() {
      boxColor = boxGrey;
      textColor = white;
    });
  }

  void changeBoxColorYellow() {
    setState(() {
      boxColor = boxYellow;
      textColor = white;
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
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
          child: Text(
        widget.alpha,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: widget.width / 1.2,
            color: textColor),
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
