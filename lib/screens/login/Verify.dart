import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordle/screens/login/SignUp.dart';
import 'package:wordle/screens/login/auth_service.dart';
import 'dart:async';
import 'package:wordle/wrapper.dart';
import 'package:wordle/constants/constants.dart';

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

    Future.delayed(const Duration(minutes: 1), () async {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user != null && !user.emailVerified) {
        await user.delete();

        Navigator.of(context).pop();
      }
    });

    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user != null && user.emailVerified) {
        timer.cancel();
        print("user has been verified");
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
      await user.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.email,
                      size: screenH / 10,
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "A verification email has been sent",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleMedium!.color!,
                        fontSize: screenH / 40,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please verify to continue.",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color!,
                        fontSize: screenH / 45,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  _auth.sendEmailVerificationLink();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).unselectedWidgetColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  "Resend Email",
                  style: TextStyle(
                      fontSize: screenH / 40,
                      fontWeight: FontWeight.w600,
                      color: darkModebg),
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () async {
                  await deleteUserAndNavigate();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).unselectedWidgetColor,
                ),
                child: Text(
                  "Back to Sign Up",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).unselectedWidgetColor),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  await deleteUserAndNavigate();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Wrapper()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: red,
                ),
                child: const Text(
                  "Continue as Guest",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
