// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
//import 'package:wordle/constants/theme.dart';

import 'package:wordle/model/dbTracker.dart';
import 'package:wordle/model/providers/userInfoProvider.dart';
import 'package:wordle/screens/home.dart';
import 'package:wordle/util/widgets/DialogWin.dart';
import 'package:wordle/util/widgets/keyboard.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wordle/util/widgets/RuleBox.dart';
import 'package:wordle/util/widgets/DialogLoss.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordle/model/dbRef.dart';
//import 'package:wordle/model/providers/instances.dart';
import 'package:provider/provider.dart';
import 'package:wordle/util/widgets/ShowNoti.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> grid = List.filled(30, '');
int currentIndex = 0;
int istart = 0, istop = 5;
late List<String> allWords;
bool? over;

class gameScreen extends StatefulWidget {
  final String word;
  final restart;
  final bool isChallenge;

  const gameScreen(
      {required this.restart,
      required this.word,
      required this.isChallenge,
      super.key});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  int counter = 0;
  final List<GlobalKey<GameBoxState>> _gameBoxKeys =
      List.generate(30, (index) => GlobalKey<GameBoxState>());
  int score = 0;
  final user = FirebaseAuth.instance.currentUser;
  final ref = DatabaseRef();
  final trackerRef = DailyTracker();
  bool isChanging = false;

  @override
  void dispose() {
    super.dispose();
  }

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
    if (ch == 'Enter' && isChanging == false) {
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
      showTopMessage(context, "Word doesn't exist, please try again.",
          const Color(0xff444242), white);
      return;
    }
    setState(() {
      isChanging = true;
    });
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
    setState(() {
      isChanging = false;
    });

    if (currentIndex == 30 && widget.word != word) {
      widget.isChallenge ? dailyGameLost() : gameLost();
    } else if (word == widget.word) {
      widget.isChallenge ? dailyGameWon() : gameWon();
    } else {
      continueGame();
    }
  }

  Future<void> dailyGameWon() async {
    int score = getScore(currentIndex);
    print(score);
    await Provider.of<UserDetailsProvider>(context, listen: false)
        .updateTheScore(score);
    print("Score is updated");
    setState(() {
      over = true;
    });

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return WinnerBoxDaily(
          restart: startMadu,
          word: widget.word,
          score: score,
        );
      },
    );
  }

  Future<void> dailyGameLost() async {
    setState(() {
      over = true;
    });

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return LoserBoxDaily(
          restart: startMadu,
          word: widget.word,
        );
      },
    );
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
          restart: startMadu,
          word: widget.word,
        );
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
          restart: startMadu,
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
  }

  Future<void> checkTheWord() async {
    var wordList = grid.sublist(istart, istop);

    await checkLetters(wordList.join(''), wordList);
  }

  bool isFirstTimeVar = false;

  void showRuleBox() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return const RuleBox();
      },
    );
  }

  Future<void> isFirstTime() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool('firstTime') ?? true;
    if (result == true) {
      prefs.setBool('firstTime', false);
      setState(() {
        isFirstTimeVar = true;
      });
      showRuleBox();
    } else {
      setState(() {
        isFirstTimeVar = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isFirstTime();

    grid = List.filled(30, '');
    currentIndex = 0;
    istart = 0;
    istop = 5;
    read_files();
    over = false;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double boxWidth = screenWidth / 7;
    double pad = screenWidth / 35;

    return Scaffold(
      appBar:
          gameAppBar(context, widget.word, widget.restart, widget.isChallenge),
      body: Container(
        padding: const EdgeInsets.only(top: 20),
        color: Theme.of(context).scaffoldBackgroundColor,
        //Theme.of(context).scaffoldBackgroundColor
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: pad * 1.5, vertical: pad * 1.5),
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
              flex: 2,
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
  late ThemeMode currentTheme;

  Color borderColor = Colors.transparent; // Initial default

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Set the initial border color based on the theme
    borderColor = Theme.of(context).textTheme.displayLarge!.color!;
  }

  Color boxColor = Colors.transparent;
  Color? textColor;

  void changeBoxColorGreen() {
    setState(() {
      boxColor = boxGreen;
      textColor = white;
      borderColor = boxGreen;
    });
  }

  void changeBoxColorGrey() {
    setState(() {
      boxColor = boxGrey;
      borderColor = boxGrey;
      textColor = white;
    });
  }

  void changeBoxColorYellow() {
    setState(() {
      boxColor = boxYellow;
      borderColor = boxYellow;
      textColor = white;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      //  textColor = Theme.of(context).textTheme.displayMedium!.color!;
    });
    return Container(
      margin: const EdgeInsets.all(2),
      height: widget.width,
      width: widget.width,
      decoration: BoxDecoration(
        color: boxColor,
        border: Border.all(
          width: 1.5,
          color: borderColor,
        ),
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

AppBar gameAppBar(
    BuildContext context, String word, restart, bool isChallenge) {
  return AppBar(
    iconTheme:
        IconThemeData(color: Theme.of(context).textTheme.bodyMedium!.color),
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(""),
        Text(
          isChallenge ? 'Daily Challenge' : 'Wordle ',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyMedium!.color,
              fontSize: 24),
        ),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            child: Icon(
              Icons.help_outline,
              color: Theme.of(context).textTheme.bodyMedium!.color,
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

int getScore(int index) {
  index = index ~/ 5;
  switch (index) {
    case 1:
      return 150;
    case 2:
      return 120;
    case 3:
      return 100;
    case 4:
      return 80;
    case 5:
      return 70;
    case 6:
      return 60;
    default:
      return 60;
  }
}
