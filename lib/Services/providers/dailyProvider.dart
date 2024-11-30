//import 'package:wordle/model/Player.dart';
import 'package:flutter/material.dart';
import 'package:wordle/Services/providers/instances.dart';

class DailyProvider extends ChangeNotifier {
  int completed = 5;
  bool updated = false;

  Future<void> getDailyChallenges() async {
    print("Getting daily challenges");
    int temp = await Instances.userTracker.getGamesCompleted();
    completed = temp;

    notifyListeners();
    print("Got daily challenges 1");
  }

  Future<void> incrementDaily() async {
    print("incrementing daily cahlelges 2");
    completed = completed + 1;
    Instances.userTracker.updateTracker(completed);
    notifyListeners();
  }
}
