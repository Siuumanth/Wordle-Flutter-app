import 'package:wordle/model/dbRef.dart';
import 'package:wordle/model/dbService.dart';
import 'package:wordle/model/dbTracker.dart';
//import 'package:wordle/model/Player.dart';

import 'package:flutter/material.dart';

class Instances extends ChangeNotifier {
  //making it static as : only single member is needed for the whole app, and to make it accessible witohut making an object
  static DatabaseService dbService = DatabaseService();
  static DailyTracker userTracker = DailyTracker();
  static DatabaseRef userRef = DatabaseRef();

  //now, whichever widget is listening to this class, will be updated cuz of notify listeners
}
