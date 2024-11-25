import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/main.dart';
import 'package:wordle/util/ShowNoti.dart';
import 'package:wordle/constants/constants.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<User?> createUserWithEmailPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          //credentials
          email: email,
          password: password);

      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionhandler(e.code);
    }
    return null;
  }

  Future<User?> loginUserWithEmailPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          //credentials
          email: email,
          password: password);

      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionhandler(e.code);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await SharedPreferences.getInstance().then((prefs) => prefs.clear());
      print("all stuff delted");
      await _auth.signOut();
      await FirebaseAuth.instance.setPersistence(Persistence.NONE);
    } catch (e) {
      print("Something went wrong");
    }
  }
}

//error handling
// common auth exceptions for firebase
exceptionhandler(String code) {
  final context = navigatorKey.currentState!.context;
  switch (code) {
    case "invalid-credential":
      print("staretd displaying invalid cred");
      showTopMessage(
          context, "Invalid login credentials, please try again", red, white);
      break;
    case "weak-password":
      print("Your password must be atleast 8 characters");
      break;

    case "email-already-in-use":
      print("User already exists");
      break;

    default:
      print("Something went wrong");
      break;
  }
}
