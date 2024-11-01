import 'package:flutter/material.dart';
//import 'package:wordle/constants.dart';

//import 'package:flutter/material.dart';

class SwapNumbersWidget extends StatefulWidget {
  const SwapNumbersWidget({Key? key}) : super(key: key);

  @override
  _SwapNumbersWidgetState createState() => _SwapNumbersWidgetState();
}

class _SwapNumbersWidgetState extends State<SwapNumbersWidget> {
  int firstNumber = 1;
  int secondNumber = 2;

  void swapNumbers() {
    setState(() {
      // Swap the numbers
      int temp = firstNumber;
      firstNumber = secondNumber;
      secondNumber = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Key Swap Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Each Text widget has a unique ValueKey to track their identity
            Text(
              '$firstNumber',
              key: ValueKey(firstNumber),
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: swapNumbers,
              child: const Text("Swap"),
            ),
            const SizedBox(height: 20),
            Text(
              '$secondNumber',
              key: ValueKey(secondNumber),
              style: const TextStyle(fontSize: 36),
            ),
          ],
        ),
      ),
    );
  }
}
