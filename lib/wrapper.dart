import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordle/screens/home.dart';
import 'package:wordle/screens/login/login.dart';
import 'package:wordle/screens/login/Verify.dart';
import 'package:wordle/screens/login/profilepick.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/model/dbRef.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int imagePickedIndex = 0;
  bool profileExists = false;

  Future<void> _reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }

  Future<void> _checkProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePickedIndex = prefs.getInt('imagePicked') ?? 0;
    });
  }

  Future<bool> _checkProfileExistsFire() async {
    final _userRef = DatabaseRef();
    User? user = FirebaseAuth.instance.currentUser;
    if (await _userRef.userDbExists(user!) == true) {
      print("User does exist");

      return true;
    } else {
      print("User does not exist");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _reloadUser();
    _checkProfileImage();

    _checkProfileExistsFire().then((exists) {
      setState(() {
        profileExists = exists;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          } else {
            final user = FirebaseAuth.instance.currentUser;

            if (user == null) {
              return const LoginScreen();
            } else {
              if (user.emailVerified == true) {
                if (profileExists == true) {
                  print("Directing to home");
                  return const HomeScreen();
                } else {
                  return ProfilePicker();
                }
              } else {
                return const VerificationScreen();
              }
            }
          }
        },
      ),
    );
  }
}
