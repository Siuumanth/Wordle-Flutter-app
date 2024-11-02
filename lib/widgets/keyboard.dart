import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double keyHeight = screenHeight * 0.07;
    print("Height and width is " +
        screenHeight.toString() +
        "and " +
        screenWidth.toString());

    List<String> kbCharacters = [
      'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', // Row 1
      'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', // Row 2
      'Enter', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'Backspace' // Row 3
    ];

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
  const ButtonBox(
      {required this.keyHeight,
      required this.screenHeight,
      required this.ch,
      required this.screenWidth,
      super.key});

  @override
  State<ButtonBox> createState() => _ButtonBoxState();
}

class _ButtonBoxState extends State<ButtonBox> {
  @override
  Widget build(BuildContext context) {
    Text text = Text(
      widget.ch,
      style: TextStyle(
          fontSize: widget.ch != "Enter"
              ? widget.keyHeight / 2.5
              : widget.keyHeight / 5,
          fontWeight: FontWeight.w700),
    );

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: kbgrey,
        ),
        height: widget.keyHeight,
        //  width: widget.screenWidth / 12.55,
        margin: EdgeInsets.all(widget.screenWidth / 130),

        child: Center(
            child:
                widget.ch != 'Backspace' ? text : const Icon(Icons.backspace)),
      ),
    );
  }
}
