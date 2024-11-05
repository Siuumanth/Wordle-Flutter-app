import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/screens/login/Login.dart';
import 'package:wordle/screens/login/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                    goToLogin();
                  },
                  child: const Text("Sign out"))
            ],
          )
        ],
      ),
    );
  }

  void goToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Login()));
  }
}

AppBar buildAppBar(context) {
  return AppBar(
      backgroundColor: theme,
      title: const Text(
        "Profile",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
      ));
}
