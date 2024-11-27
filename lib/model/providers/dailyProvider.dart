//import 'package:wordle/model/Player.dart';
import 'package:flutter/material.dart';
import 'package:wordle/model/providers/instances.dart';

class DailyProvider extends ChangeNotifier {
  int completed = 5;
  bool updated = false;
  Future<void> getDailyChallenges() async {
    print("Getting daily challenges");
    int temp = await Instances.userTracker.getGamesCompleted();
    completed = temp;
    notifyListeners();
  }

  Future<void> incrementDaily() async {
    print("incrementing daily cahlelges 2");
    completed = completed + 1;
    Instances.userTracker.updateTracker(completed);
    notifyListeners();
  }
}
