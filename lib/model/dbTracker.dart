import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailyTracker {
  final tracker = FirebaseDatabase.instance.ref("dailyTracker");
//define user here instead of repeatedly calling

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

  Future<void> updateEveryday(User user) async {
    var snapshot =
        await tracker.orderByChild("email").equalTo(user.email).get();
    String currentDateTime = DateTime.now().toUtc().toString().substring(0, 16);
    late String dateToCompare;
    late String timeToCompare;
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

    Map<String, dynamic> dateTimeToCompare = await dateParser(_temp);
    Map<String, dynamic> current = await dateParser(currentDateTime);
  }

  Future<Map<String, dynamic>> dateParser(String _temp) async {
    return {
      "year": int.parse(_temp.substring(0, 4)),
      "month": int.parse(_temp.substring(5, 7)),
      "day": int.parse(_temp.substring(8, 10)),
      "hour": int.parse(_temp.substring(11, 12)),
      "minutes": int.parse(_temp.substring(13, 15))
    };
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
