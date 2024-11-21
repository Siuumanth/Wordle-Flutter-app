import 'package:firebase_database/firebase_database.dart';
import 'Player.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailyTracker {
  final tracker = FirebaseDatabase.instance.ref("dailyTracker");

  Future<void> updateTracker(User user) async {
    final query = tracker.orderByChild("email").equalTo(user.email);
    final snapshot = await query.get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      final key = data.keys.first;
      await tracker.child(key).update(
          {"lastDateTime": DateTime.now().toUtc().toString().substring(0, 16)});
    } else {
      print("User not found");
    }
  }

  Future<String> getLastDateTime(User user) async {
    var snapshot =
        await tracker.orderByChild("email").equalTo(user.email).get();

    if (snapshot.exists) {
      Map fullMap = snapshot.value as Map;
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(fullMap.values.first);
      print(userData);

      return userData['lastDateTime'];
    } else {
      print("User not found");
      return "0";
    }
  }

  Future<int> getGamesCompleted(User user) async {
    var snapshot =
        await tracker.orderByChild("email").equalTo(user.email).get();

    if (snapshot.exists) {
      Map fullMap = snapshot.value as Map;
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(fullMap.values.first);
      print(userData);
      print("Games played : ${userData['gamesPlayed']}");
      return userData['gamesPlayed'];
    } else {
      print("User not found");
      return 0;
    }
  }
}
