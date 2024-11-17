import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:wordle/constants.dart';
import 'package:wordle/screens/login/Login.dart';
import 'package:wordle/screens/login/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordle/main.dart';
import 'package:wordle/model/dbRef.dart';
import 'package:wordle/model/Player.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _userRef = DatabaseRef();
  final _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser;
  late profileUser userDetails;
  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    userDetails = await _userRef.getUserDetails(user!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 50, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              const Text(
                "Name",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Rank
              const Text(
                "Rank: #1",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 5),

              // Score
              const Text(
                "Score: 1200",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const Spacer(),

              // Sign Out Button
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text("Sign Out"),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text("Delete Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Removes all previous routes
    );
  }

  Future<void> deleteAccount() async {
    if (user != null) {
      await user!.delete();
    }
  }
}

AppBar buildAppBar(context) {
  return AppBar(
    backgroundColor: theme,
    title: const Text(
      "Profile",
      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
    ),
  );
}
