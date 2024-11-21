import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailyTracker {
  final tracker = FirebaseDatabase.instance.ref("dailyTracker");
  final user = FirebaseAuth.instance.currentUser;

  Future<void> updateTracker(User user, int gameNo) async {
    final query = tracker.orderByChild("email").equalTo(user.email);
    final snapshot = await query.get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      final key = data.keys.first;
      await tracker.child(key).update({
        "lastDateTime": DateTime.now().toUtc().toString().substring(0, 16),
        'gamesPlayed': gameNo
      });
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

  Future<void> updateEveryday() async {
    var snapshot =
        await tracker.orderByChild("email").equalTo(user!.email).get();
    String currentDateTime = DateTime.now().toUtc().toString().substring(0, 16);
    late String _temp;
    if (snapshot.exists) {
      Map fullMap = snapshot.value as Map;
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(fullMap.values.first);
      print(userData);

      _temp = userData['lastDateTime'];
    } else {
      return;
    }
    currentDateTime = "2024-11-22 00:00";
    Map<String, dynamic> dateTimeToCompare = await dateParser(_temp);
    Map<String, dynamic> current = await dateParser(currentDateTime);
    await updateOrNot(current, dateTimeToCompare);
    return;
  }

  Future<Map<String, dynamic>> dateParser(String _temp) async {
    return {
      'y': int.parse(_temp.substring(0, 4)),
      'mo': int.parse(_temp.substring(5, 7)),
      'd': int.parse(_temp.substring(8, 10)),
      'h': int.parse(_temp.substring(11, 13)),
      'mi': int.parse(_temp.substring(14, 16))
    };
  }

  Future<void> updateOrNot(Map current, Map compare) async {
    bool y = current['y'] == compare['y'];
    bool mo = current['mo'] == compare['mo'];
    bool d = current['d'] == compare['d'];

    if (!y || !mo || !d) {
      //different day
      await resetTracker(); // 5:30 is over
      print("tracker has been resetted");
    } else if (y && mo && d) {
      //same day
      print("Tracker has not been reset");
      return;
    }

    return;
  }

  Future<void> resetTracker() async {
    final query = tracker.orderByChild("email").equalTo(user!.email);
    final snapshot = await query.get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);

      final key = data.keys.first;
      await tracker.child(key).update({'gamesPlayed': 0});
    } else {
      print("User not found");
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
