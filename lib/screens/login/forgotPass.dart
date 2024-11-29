//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:wordle/screens/login/Login.dart';
import 'package:wordle/screens/login/auth_service.dart';
import 'package:wordle/screens/login/SignUp.dart';
import 'package:wordle/constants/constants.dart';
import 'package:wordle/util/ShowNoti.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = AuthService();

  @override
  void initState() {
    super.initState();
  }

  late TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Enter your email to reset your password",
                style: TextStyle(fontSize: screenH / 40),
              ),
            ),
            const SizedBox(height: 5),
            textField(
              emailController,
              const Icon(Icons.email),
              "Email",
              1,
              TextInputType.emailAddress,
              false,
              context,
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                height: screenH / 20,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).unselectedWidgetColor,
                      foregroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      padding: const EdgeInsets.only(left: 20, right: 20)),
                  onPressed: () async {
                    final email = emailController.text;
                    if (email.isNotEmpty) {
                      showTopMessage(context, "Password reset link sent", theme,
                          darkModebg);
                      _auth.sendPasswordResetLink(email);
                    } else {
                      showTopMessage(context, "Please enter your email", theme,
                          darkModebg);
                    }
                  },
                  child: Text(
                    "Reset Password",
                    style: TextStyle(fontSize: screenH / 55),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenH / 10,
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).unselectedWidgetColor,
                ),
                child: Text(
                  "Back to Login",
                  style: TextStyle(
                      fontSize: screenH / 45,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).unselectedWidgetColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
