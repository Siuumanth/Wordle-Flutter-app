import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:wordle/screens/home.dart';
import 'package:wordle/screens/login/login.dart';
import 'package:wordle/screens/login/Verify.dart';
import 'package:wordle/screens/login/profilepick.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? user = FirebaseAuth.instance.currentUser;

  bool trackerExists = false;
  bool trackerStatusGot = false;

  Future<void> _reloadUser() async {
    print("reloading wrapper");
    try {
      await FirebaseAuth.instance.currentUser?.reload();
    } catch (e) {
      print("User is offline");
    }
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
      print("user DB does not exists");
      return false;
    }
  }

  Future<bool> _checkTrackerExists() async {
    if (await Instances.userTracker.userTrackerExists() == true) {
      setState(() {
        trackerExists = true;
        trackerStatusGot = true;
      });

      print("User and tracker does exist");

      return true;
    } else {
      print("user tracker does not exists");
      setState(() {
        trackerExists = false;
        trackerStatusGot = true;
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _reloadUser();

      _checkTrackerExists().then((exists) {
        setState(() {
          trackerExists = exists;
        });
      });
    }
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
              print("user is null");
              return const LoginScreen();
            } else {
              if (user!.emailVerified == true) {
                if (trackerExists == true) {
                  return const HomeScreen();
                } else {
                  if (trackerStatusGot == false) {
                    return const CircularProgressIndicator();
                  }
                  return const ProfilePicker();
                }
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
