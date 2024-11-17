import 'package:firebase_database/firebase_database.dart';
import 'Player.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseRef {
  final userRef = FirebaseDatabase.instance.ref("users");

  getUserDetails(User user) {
    userRef.orderByChild("email").equalTo(user.email).get().then((snapshot) {
      if (snapshot.exists) {
        Map<dynamic, dynamic> userData =
            snapshot.value as Map<dynamic, dynamic>;
        print(userData);
        return profileUser(
            username: userData['name'],
            email: userData['email'],
            score: userData['score'],
            pfp: userData['pfp'],
            rank: userData['rank']);
      } else {
        print("No user found with this email.");
      }
    });
  }
}
