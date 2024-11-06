import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordle/screens/login/auth_service.dart';
import 'dart:async';

import 'package:wordle/wrapper.dart';

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

    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        timer.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Wrapper()));
      }
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "A Verification email has been sent, please verify it to continue"),
              ElevatedButton(
                  onPressed: () async {
                    _auth.sendEmailVerificationLink();
                  },
                  child: const Text("Resend Email"))
            ],
          ),
        ),
      ),
    );
  }
}
