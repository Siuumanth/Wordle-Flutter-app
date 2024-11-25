import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:wordle/screens/home.dart';
import 'package:wordle/screens/login/login.dart';
import 'package:wordle/screens/login/Verify.dart';
import 'package:wordle/screens/login/profilepick.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? user = FirebaseAuth.instance.currentUser;

  bool profileExists = false;

  Future<void> _reloadUser() async {
    print("Reloading");
    await FirebaseAuth.instance.currentUser?.reload();
    print("Reloading done");
  }

  Future<bool> _checkProfileExistsFire() async {
    if (user == null) {
      print("User does not exist");
      return false;
    }

    if (await Instances.userRef.userDbExists() == true) {
      print("User does exist");

      return true;
    } else {
      print("smth happen");
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _reloadUser();

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
            if (user == null) {
              return const LoginScreen();
            } else {
              if (user!.emailVerified == true) {
                return const HomeScreen();
              } else if (user!.emailVerified == false) {
                return const VerificationScreen();
              } else {
                return const HomeScreen();
              }
            }
          }
        },
      ),
    );
  }
}
