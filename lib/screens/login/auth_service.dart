import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  switch (code) {
    case "invalid-credential":
      print("invalid login credential");

    case "weak-password":
      print("Your password must be atleast 8 characters");

    case "email-already-in-use":
      print("User already exists");

    default:
      print("Something went wrong");
  }
}
