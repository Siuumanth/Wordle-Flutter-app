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

      return profileUser(
          username: userData['name'],
          email: userData['email'],
          score: userData['score'],
          pfp: userData['pfp'],
          rank: userData['rank']);
    } else {
      print("No user found with this email.");
      return null;
    }
  }
}
