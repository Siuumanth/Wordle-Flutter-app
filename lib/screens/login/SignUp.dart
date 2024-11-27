import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
import 'package:wordle/screens/login/Login.dart';
import 'package:wordle/screens/login/auth_service.dart';
import 'package:wordle/screens/login/profilepick.dart';
import 'package:wordle/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/wrapper.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _auth = AuthService();
  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController passController = TextEditingController();
  String verify = "Verify";

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
    nameController.dispose();
  }

  Future<void> saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', nameController.text);
    print("Name has been saved");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginAppBar(context),
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Signup",
                  style: TextStyle(
                      fontSize: 35, fontWeight: FontWeight.w600, color: grey),
                ),
                const SizedBox(
                  height: 30,
                ),
                textField(
                    nameController,
                    const Icon(
                      Icons.account_circle_sharp,
                      color: grey,
                      size: 30,
                    ),
                    "Username",
                    0,
                    TextInputType.emailAddress),
                const SizedBox(
                  height: 30,
                ),
                textField(
                    emailController,
                    const Icon(
                      Icons.mail,
                      color: grey,
                      size: 30,
                    ),
                    "Enter your email",
                    0,
                    TextInputType.emailAddress),
                const SizedBox(
                  height: 30,
                ),
                textField(
                    passController,
                    const Icon(
                      Icons.lock,
                      color: grey,
                      size: 30,
                    ),
                    "Set password",
                    0,
                    TextInputType.visiblePassword),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                              color: darktheme,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: darktheme,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.only(left: 45, right: 45)),
                    onPressed: () {
                      _signup();
                    },
                    child: Center(
                      child: Text(
                        verify,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                GestureDetector(
                  onTap: () {
                    goToHome(context);
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void goToProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  void goToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<User?> _signup() async {
    print("start");
    final user = await _auth.createUserWithEmailPassword(
        emailController.text, passController.text);
    print("stop");
    if (user != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Wrapper()),
        (Route<dynamic> route) => false,
      );
    } else {
      return null;
    }
    saveName();
    return null;
  }
}

AppBar loginAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: white,
    title: const Row(
      children: [
        Text(
          ' ',
          style: TextStyle(
              fontWeight: FontWeight.w400, color: black, fontSize: 24),
        ),
      ],
    ),
  );
}

Widget textField(TextEditingController contr, Widget icon, String hintext,
    int max, TextInputType inputType) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    height: 60,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: theme, width: 2),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 25),
    child: TextField(
      cursorHeight: 30,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w400, color: grey),
      controller: contr,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.only(bottom: -2, left: 15, right: 30, top: 10),
        border: InputBorder.none,
        hintText: hintext,
        prefixIcon: icon,
        prefixIconConstraints:
            const BoxConstraints(maxHeight: 15, minWidth: 50),
      ),
      maxLength: hintext == "Username" ? 10 : null,
      keyboardType: inputType,
    ),
  );
}
