import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordle/screens/login/SignUp.dart';
import 'package:wordle/screens/login/auth_service.dart';
import 'dart:async';
import 'package:wordle/wrapper.dart';
import 'package:wordle/constants.dart';
import 'Login.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _auth = AuthService();
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _auth.sendEmailVerificationLink();

    // Set a delay to delete the user if email is not verified
    Future.delayed(const Duration(minutes: 1), () async {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user != null && !user.emailVerified) {
        await user.delete();
        // Close the app after deleting the user
        Navigator.of(context).pop();
      }
    });

    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user != null && user.emailVerified) {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Wrapper()),
        );
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> deleteUserAndNavigate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user
          .delete(); // Delete the user if they press continue as guest or back to sign up
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "A verification email has been sent. Please verify to continue.",
            ),
            ElevatedButton(
              onPressed: () async {
                _auth.sendEmailVerificationLink();
              },
              child: const Text("Resend Email"),
            ),
            GestureDetector(
              onTap: () async {
                // Delete user before navigating back to SignUp
                await deleteUserAndNavigate();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                );
              },
              child: const Text(
                "Back to Sign up",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darktheme,
                    decoration: TextDecoration.underline,
                    decorationColor: darktheme),
              ),
            ),
            GestureDetector(
              onTap: () async {
                // Delete user before navigating as a guest
                await deleteUserAndNavigate();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Wrapper()),
                );
              },
              child: const Text(
                "Continue as guest",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darktheme,
                    decoration: TextDecoration.underline,
                    decorationColor: darktheme),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
