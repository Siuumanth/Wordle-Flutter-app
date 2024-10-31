import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(BuildContext),
      body: Stack(
        children: [buildFAB(), buildStartButton()],
      ),
    );
  }
}

Widget buildFAB() {
  return Padding(
    padding: const EdgeInsets.only(left: 8.0, top: 20),
    child: SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        backgroundColor: darktheme,
        shape: const CircleBorder(),
        onPressed: () {},
        child: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Image.asset('assets/images/trophy.png'),
        ),
      ),
    ),
  );
}

Widget buildStartButton() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 160,
          width: 160,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme, foregroundColor: grey),
              onPressed: () {},
              child: const Center(
                child: Text(
                  "START",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
              )),
        )
      ],
    ),
  );
}

AppBar buildAppBar(context) {
  return AppBar(
    backgroundColor: theme,
    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Icon(Icons.menu, color: grey, size: 30),
      const Text(
        'WORDLE',
        style:
            TextStyle(fontWeight: FontWeight.w600, color: grey, fontSize: 24),
      ),
      Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: GestureDetector(
            child: ClipOval(
              child: Image.asset('assets/images/mepic.jpg'),
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
