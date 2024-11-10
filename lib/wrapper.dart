import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  int imagePickedIndex = 0;

  Future<void> _reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }

  Future<void> _checkProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      imagePickedIndex = prefs.getInt('imagePicked') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _reloadUser();
    _checkProfileImage();
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
                if (imagePickedIndex != 0) {
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
