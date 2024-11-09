// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/widgets/DialogWin.dart';
import 'package:wordle/widgets/keyboard.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wordle/widgets/RuleBox.dart';
import 'package:wordle/widgets/DialogLoss.dart';

List<String> grid = List.filled(30, '');
int currentIndex = 0;
int istart = 0, istop = 5;
late List<String> allWords;
bool? over;

class gameScreen extends StatefulWidget {
  final String word;
  final restart;
  final popmethod;
  const gameScreen(
      {required this.popmethod,
      required this.restart,
      required this.word,
      super.key});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  int counter = 0;
  final List<GlobalKey<GameBoxState>> _gameBoxKeys =
      List.generate(30, (index) => GlobalKey<GameBoxState>());

  @override
  void initState() {
    super.initState();
    grid = List.filled(30, '');
    currentIndex = 0;
    istart = 0;
    istop = 5;
    read_files();
    over = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: non_constant_identifier_names
  Future<void> read_files() async {
    String contentsA = await rootBundle.loadString("assets/twelveK.txt");
    allWords = contentsA.split('\n');
  }

  int binarySearch(String target) {
    int left = 0;
    int right = allWords.length - 1;

    while (left <= right) {
      int mid = left + (right - left) ~/ 2;

      if (allWords[mid].substring(0, 5).toUpperCase() == target) {
        return mid;
      } else if (allWords[mid].substring(0, 5).toUpperCase().compareTo(target) <
          0) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    return -1;
  }

  void changeAlpha(String alpha) {
    if (alpha == "Enter") {
      return;
    }
    setState(() {
      grid[currentIndex] = alpha;
      currentIndex++;
      print(currentIndex);
    });
  }

  void backSpace() {
    if (currentIndex == istart) {
      return;
    } else if (over == true) {
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
    int checker = binarySearch(word);
    if (checker == -1) {
      showSnackBar("Word doesn't exist, try again");
      return;
    }
    for (int i = 0; i < 5; i++) {
      if (alphaList[i] == correctAlphaList[i]) {
        _gameBoxKeys[istart + i].currentState!.changeBoxColorGreen();
        buttonBoxKeys[kbCharacters.indexOf(alphaList[i])]
            .currentState!
            .changeButtonColorGreen();
      } else if (widget.word.contains(alphaList[i])) {
        _gameBoxKeys[istart + i].currentState!.changeBoxColorYellow();
        buttonBoxKeys[kbCharacters.indexOf(alphaList[i])]
            .currentState!
            .changeButtonColorYellow();
      } else {
        _gameBoxKeys[istart + i].currentState!.changeBoxColorGrey();
        buttonBoxKeys[kbCharacters.indexOf(alphaList[i])]
            .currentState!
            .changeButtonColorGrey();
      }
      await Future.delayed(const Duration(seconds: 0, milliseconds: 300));
    }
    if (currentIndex == 30 && widget.word != word) {
      gameLost();
    } else if (word == widget.word) {
      gameWon();
    } else {
      continueGame();
    }
  }

  Future<void> gameWon() async {
    setState(() {
      over = true;
    });
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return WinnerBox(
            restart: widget.restart,
            word: widget.word,
            popmethod: widget.popmethod);
      },
    );
  }

  Future<void> gameLost() async {
    setState(() {
      over = true;
    });
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return LoserBox(
          word: widget.word,
          restart: widget.restart,
          popmethod: widget.popmethod,
        );
      },
    );
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

    await checkLetters(wordList.join(''), wordList);
  }

  void showSnackBar(String snackText) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          snackText,
          style: const TextStyle(color: grey),
        ),
        backgroundColor: white,
        dismissDirection: DismissDirection.horizontal,
        showCloseIcon: true,
        elevation: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double boxWidth = screenWidth / 7;
    double pad = screenWidth / 35;

    return Scaffold(
      appBar:
          gameAppBar(context, widget.word, widget.restart, widget.popmethod),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        color: white,
        child: Column(
          children: [
            Expanded(
              flex: 4, // Adjust the flex to occupy more space
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: pad * 1.3, vertical: pad * 1.3),
                child: GridView.count(
                  crossAxisCount: 5,
                  physics: const BouncingScrollPhysics(),
                  children: List.generate(
                    30,
                    (index) {
                      return GameBox(
                          width: boxWidth,
                          key: _gameBoxKeys[index],
                          alpha: grid[index]);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2, // Adjust the flex to control the height of the keyboard
              child: Container(
                margin: const EdgeInsets.all(10),
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
        border: Border.all(
            width: 1.5, color: const Color.fromARGB(177, 26, 25, 25)),
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

AppBar gameAppBar(BuildContext context, String word, restart, popmethod) {
  return AppBar(
    backgroundColor: white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(""),
        const Text(
          'WORDLE  ',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: black, fontSize: 24),
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
                  return const RuleBox();
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}
