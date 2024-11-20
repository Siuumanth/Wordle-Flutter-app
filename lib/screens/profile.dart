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

bool loaded = false;

class _ProfilePageState extends State<ProfilePage> {
  final _userRef = DatabaseRef();
  final _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser;
  late profileUser? userDetails;

  @override
  void initState() {
    super.initState();
    getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    print("starting getting");
    userDetails = await _userRef.getUserDetails(user!);

    setState(() {
      loaded = true;
    });
    print("finished getting");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: buildAppBar(context),
      body: loaded == false
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        child: Image.asset(
                            'assets/profiles/${userDetails!.pfp}.png'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      userDetails!.username,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Rank: ${userDetails!.rank == 0 ? "Not Played" : userDetails!.rank}",
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Score: ${userDetails!.score}",
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const Spacer(),
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
