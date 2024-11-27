import 'package:firebase_database/firebase_database.dart';
import 'Player.dart';

class DatabaseService {
  final _real = FirebaseDatabase.instance;

  rlcreate(profileUser user) {
    try {
      _real.ref("users").push().set(user.toMap());
      print('saved user in rlcreate');
    } catch (e) {
      print('could not save user in rlcreate');
      print(e.toString());
    }
  }

  Future<void> postInitialTracker(userDailyTracker user) async {
    try {
      _real.ref("dailyTracker").push().set(user.toMap());
      print("tracker is initialised");
    } catch (e) {
      print(e.toString());
    }
  }

/*
  rlRead() async {
    try {
      final data = await _real.ref("users").once();

      for (int i = 0; i < data.snapshot.children.length; i++) {
        print(data.snapshot.children.toList()[i].value.toString());
        print("----------\n");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  rlUpdate() async {
    try {
      await _real.ref("users").child("user1").update({"name": "chubs_3d"});
    } catch (e) {}
  }

  rlDelete() async {
    try {
      await _real.ref("users").child("user2").remove();
    } catch (e) {}
  }*/
}
