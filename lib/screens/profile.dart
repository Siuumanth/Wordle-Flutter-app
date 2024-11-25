import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
import 'package:wordle/screens/login/Login.dart';
import 'package:wordle/screens/login/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wordle/main.dart';
import 'package:wordle/model/Player.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:wordle/model/providers/userInfoProvider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool loaded = false;

  final _auth = AuthService();
  final user = FirebaseAuth.instance.currentUser;
  late profileUser? userDetails;

  @override
  void initState() {
    super.initState();
    // getProfileDetails();
  }

  Future<void> getProfileDetails() async {
    print("starting getting");
    userDetails = await Instances.userRef.getUserDetails();

    setState(() {
      loaded = true;
    });
    print("finished getting");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<UserDetailsProvider>(
      builder: (context, userData, child) => Scaffold(
        appBar: buildAppBar(context),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 35,
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  width: screenWidth / 3.5 * 2,
                  height: screenWidth / 3.5 * 2,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: darkertheme,
                  ),
                  child: CircleAvatar(
                    radius: screenWidth / 17 - 20,
                    child: ClipOval(
                      child: Image.asset(
                        "assets/profiles/${userData.userDetails!.pfp}.png",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  userData.userDetails!.username,
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                const Text(
                  "Your rank is",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(211, 31, 31, 31)),
                ),
                Stack(
                  children: [
                    const Icon(Icons.tornado_outlined),
                    Text(
                      "1",
                      style: TextStyle(fontSize: screenHeight / 8),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  "Score: ${userData.userDetails!.score}",
                  style: TextStyle(
                      fontSize: screenWidth / 18,
                      color: const Color.fromARGB(255, 107, 107, 107)),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: theme,
                      foregroundColor: darkertheme,
                      textStyle: TextStyle(
                          color: darkerertheme,
                          fontSize: screenWidth / 20,
                          fontWeight: FontWeight.w700)),
                  onPressed: () async {
                    await _auth.signOut();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const MyApp(),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.all(14),
                      child: const Text("Sign Out")),
                ),
                const SizedBox(height: 10),
              ],
            ),
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
