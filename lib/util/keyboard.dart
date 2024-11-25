import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
import 'package:wordle/screens/gamescreen.dart';

//import 'package:wordle/screens/gamescreen.dart';

late List<GlobalKey<_ButtonBoxState>> buttonBoxKeys;
int value = 1;

List<String> kbCharacters = [
  'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', // Row 1
  'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', // Row 2
  'Enter', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Backspace' // Row 3
];

class CustomKeyboard extends StatefulWidget {
  final changeAlpha;
  final backSpace;
  final fiveDone;
  const CustomKeyboard(
      {required this.fiveDone,
      required this.backSpace,
      required this.changeAlpha,
      super.key});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  @override
  void initState() {
    super.initState();
    print("List initialized");
    print("${value}Value");
    buttonBoxKeys = List.generate(28, (index) => GlobalKey<_ButtonBoxState>());
    value++;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double keyHeight = screenHeight * 0.08;

    Widget kbRow(int start, int end) {
      return Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (String ch in kbCharacters.sublist(start, end))
              Expanded(
                child: ButtonBox(
                  screenWidth: screenWidth,
                  ch: ch,
                  screenHeight: screenHeight,
                  keyHeight: keyHeight,
                  changeAlpha: widget.changeAlpha,
                  backSpace: widget.backSpace,
                  fiveDone: widget.fiveDone,
                  key: buttonBoxKeys[kbCharacters.indexOf(ch)],
                ),
              )
          ],
        ),
      );
    }

    return Container(
        child: Column(children: [
      kbRow(0, 10),
      kbRow(10, 19),
      kbRow(19, 28),
    ]));
  }
  //Column(children: [GridView.count(crossAxisCount: 10)])
}

class ButtonBox extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final double keyHeight;
  final String ch;
  final backSpace;
  final changeAlpha;
  final fiveDone;

  const ButtonBox(
      {required this.keyHeight,
      required this.screenHeight,
      required this.ch,
      required this.screenWidth,
      required this.changeAlpha,
      required this.backSpace,
      required this.fiveDone,
      super.key});

  @override
  State<ButtonBox> createState() => _ButtonBoxState();
}

class _ButtonBoxState extends State<ButtonBox> {
  Color keyColor = kbgrey;
  Color keyTextColor = const Color.fromARGB(255, 34, 34, 34);

  void changeButtonColorGreen() {
    setState(() {
      keyColor = boxGreen;
      keyTextColor = white;
    });
  }

  void changeButtonColorGrey() {
    setState(() {
      keyColor = boxGrey;
      keyTextColor = white;
    });
  }

  void changeButtonColorYellow() {
    setState(() {
      keyColor = keyColor == boxGreen ? boxGreen : boxYellow;
      keyTextColor = white;
    });
  }

  void changeButtonColorWhite() {
    setState(() {
      keyTextColor = Colors.white;
    });
  }

  bool isFiveDone() {
    return (currentIndex == istop) && currentIndex <= grid.length;
  }

  @override
  Widget build(BuildContext context) {
    Text text = Text(
      widget.ch,
      style: TextStyle(
          fontSize: widget.ch != "Enter"
              ? widget.keyHeight / 3
              : widget.keyHeight / 5,
          fontWeight: FontWeight.w700,
          color: keyTextColor),
    );

    return InkWell(
      onTap: () {
        if (!isFiveDone()) {
          if (widget.ch != 'Backspace') {
            widget.changeAlpha(widget.ch);
          } else {
            widget.backSpace();
          }
        } else {
          widget.fiveDone(widget.ch);
        }
      }, // Change here

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: keyColor,
        ),
        height: widget.keyHeight,
        margin: EdgeInsets.all(widget.screenWidth / 140),
        child: Center(
            child: widget.ch != 'Backspace'
                ? text
                : const Icon(
                    Icons.backspace,
                  )),
      ),
    );
  }
}
