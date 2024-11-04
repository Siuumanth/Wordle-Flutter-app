import 'dart:io';

void main() async {
  var file = File('words/filtered-words.txt');

  try {
    String contents = await file.readAsString();
    List<String> fwords = contents.split('\n');

    for (int i = 1; i <= 50; i++) {
      //   print(fwords[i]);
    }
    print(fwords);
  } catch (e) {
    print('Error reading file: $e');
  }
}

/*
  var fwordfile = File('words/filtered-words.txt');
  var valWordfile = File('words/twelveK.txt');

   String contentsF = await fwordfile.readAsString();
   String contentsT = await valWordfile.readAsString();

  List<String> fwords = await contentsF.split('\n');
  List<String> valwords = await contentsF.split('\n');*/