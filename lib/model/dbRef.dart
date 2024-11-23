import 'package:firebase_database/firebase_database.dart';
import 'Player.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseRef {
  final userRef = FirebaseDatabase.instance.ref("users");

  Future<profileUser?> getUserDetails(User user) async {
    var snapshot =
        await userRef.orderByChild("email").equalTo(user.email).get();

    if (snapshot.exists) {
      Map fullMap = snapshot.value as Map;
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(fullMap.values.first);
      print(userData);
      print(userData['score'].runtimeType);
      return profileUser(
        username: userData['name'],
        email: userData['email'],
        score: userData['score'],
        pfp: userData['pfp'],
      );
    } else {
      print("No user found with this email.");
      return null;
    }
  }

  Future<int> getFirePfp(User user) async {
    var snapshot =
        await userRef.orderByChild("email").equalTo(user.email).get();

    if (snapshot.exists) {
      Map fullMap = snapshot.value as Map;
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(fullMap.values.first);
      print(userData);

      return int.parse(userData['pfp']);
    } else {
      return 0;
    }
  }

  Future<bool> userDbExists(User user) async {
    var snapshot =
        await userRef.orderByChild("email").equalTo(user.email).get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> updateScore(User user, int score) async {
    final query = userRef.orderByChild("email").equalTo(user.email);
    final snapshot = await query.get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      int currentScore = data.values.first['score'];

      int finalScore = currentScore + score;
      final key = data.keys.first;
      await userRef.child(key).update({"score": finalScore});
    } else {
      print("User not found");
    }
  }

// leaderboard stuff

  Future<List<leaderBoardDetails>> getLeaderBoard() async {
    var snapshot = await userRef.orderByChild("score").get();
    List<leaderBoardDetails> leaderBoardList = [];
    if (snapshot.exists) {
      Map fullMap = snapshot.value as Map;

      fullMap.forEach((key, value) {
        leaderBoardDetails temp = leaderBoardDetails(
            pfp: value['pfp'], username: value['name'], score: value['score']);
        leaderBoardList.add(temp);
      });
      print(leaderBoardList);
    }
    return leaderBoardList;
  }
}
