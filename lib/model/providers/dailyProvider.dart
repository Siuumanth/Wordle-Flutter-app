//import 'package:wordle/model/Player.dart';
import 'package:flutter/material.dart';
import 'package:wordle/model/providers/instances.dart';

class DailyProvider extends ChangeNotifier {
  int completed = 5;

  Future<void> getDailyChallenges() async {
    int temp = await Instances.userTracker.getGamesCompleted();
    completed = temp;
    notifyListeners();
  }

  Future<void> incrementDaily() async {
    completed++;
    Instances.userTracker.updateTracker(completed);
    notifyListeners();
  }
}
