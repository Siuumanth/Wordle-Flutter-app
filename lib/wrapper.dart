import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:wordle/screens/home.dart';
import 'package:wordle/screens/login/login.dart';
import 'package:wordle/screens/login/Verify.dart';
import 'package:wordle/screens/login/profilepick.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? user = FirebaseAuth.instance.currentUser;

  bool trackerExists = false;
  bool isLoading = false;
  bool online = false;

  Future<void> isInternetAvailable() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult[0] == ConnectivityResult.none) {
        setState(() {
          print("Online has been set false");
          online = false;
          return;
        });
      }
      final result = await http.get(Uri.parse('https://www.google.com'));
      if (result.statusCode == 200) {
        online = true;
        print("Online has been set true");
        return;
      }
    } catch (e) {
      print('Error checking internet availability: $e');
      online = false;
      print("Online has been set false");
      return;
    }

    online = false;
    print("Online has been set false");
  }

  Future<void> _reloadUser() async {
    user = FirebaseAuth.instance.currentUser;
    user!.reload();
    if (user == null) {
      return;
    }
    print("reloading wrapper");
    try {
      await user!.reload();
    } catch (e) {
      print("User is offline");
    }
  }

  Future<bool> _checkTrackerExists() async {
    if (await Instances.userTracker.userTrackerExists() == true) {
      setState(() {
        trackerExists = true;
      });

      print("User and tracker does exist");

      return true;
    } else {
      print("user tracker does not exists");
      setState(() {
        trackerExists = false;
      });
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      isLoading = true;
    });

    await isInternetAvailable();
    if (user != null && online) {
      await initialFunction();
    }
    print("Tracker exists init state = $trackerExists");
    print(
        "User exists ? init state= ${FirebaseAuth.instance.currentUser != null}");
    print("Online or not init state: $online");
    setState(() {
      isLoading = false;
    });
  }

  Future<void> initialFunction() async {
    await _reloadUser();
    await _checkTrackerExists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                isLoading == true) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error"));
            } else {
              if (FirebaseAuth.instance.currentUser != null) {
                if (FirebaseAuth.instance.currentUser!.emailVerified == false) {
                  print("Directing to verification screen");
                  return const VerificationScreen();
                }
                if (trackerExists && online) {
                  print("Directing to Home screen");
                  return const HomeScreen();
                } else if (trackerExists == false && online) {
                  print("Directing to Profile picker screen");
                  return const ProfilePicker();
                }
              } else {
                print("Directing to Login screen");
                return const LoginScreen();
              }
            }
            print("Online or not : $online");
            print("Tracker exists = $trackerExists");
            print("User exists ? = ${user == null}");
            print("none of the conditions met");
            return const HomeScreen();
          }),
    );
  }
}
