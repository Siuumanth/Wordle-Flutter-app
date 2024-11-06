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
            if (snapshot.data == null) {
              //not logged in
              //check if the email is verified first

              return const LoginScreen();
            } else {
              if (snapshot.data?.emailVerified == true) {
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
