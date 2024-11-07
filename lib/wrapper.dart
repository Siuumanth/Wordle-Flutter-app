import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordle/screens/home.dart';
import 'package:wordle/screens/login/login.dart';
import 'package:wordle/screens/login/Verify.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  // This ensures the user's status is refreshed each time the app opens
  Future<void> _reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
  }

  @override
  void initState() {
    super.initState();
    _reloadUser(); // Reload user data on app open
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
              // Not logged in
              return const LoginScreen();
            } else {
              if (user.emailVerified == true) {
                return const HomeScreen();
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
