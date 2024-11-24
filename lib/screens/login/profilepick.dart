import 'package:flutter/material.dart';
import 'package:wordle/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:wordle/model/providers/userInfoProvider.dart';
import '../../model/Player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/wrapper.dart';
import 'package:wordle/model/providers/instances.dart';
//error handling neeeded

class ProfilePicker extends StatefulWidget {
  const ProfilePicker({super.key});

  @override
  _ProfilePickerState createState() => _ProfilePickerState();
}

class _ProfilePickerState extends State<ProfilePicker> {
  final user = FirebaseAuth.instance.currentUser;
  String? userName;
  int _selectedProfileIndex = 1;

  void _selectProfile(int index) {
    setState(() {
      _selectedProfileIndex = index;
    });
  }

  Future<void> getName() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Future<void> saveDetailsInFire(int pfp) async {
      try {
        final userToSave = profileUser(
          username: userName!,
          email: user!.email!,
          score: 0,
          pfp: pfp.toString(),
        );
        await Instances.dbService.rlcreate(userToSave);
        final userTrackerSave = userDailyTracker(
            email: user!.email!, lastDatePlayedTime: "", gamesPlayed: 0);

        await Instances.dbService.postInitialTracker(userTrackerSave);
        /* Provider.of<UserDetailsProvider>(context, listen: false)
            .saveMapToSharedPreferences(userToSave.toMap());*/
      } catch (e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Failed to save profile. Please try again.")),
        );
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Profile Picture',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CircleAvatar(
              radius: 80,
              backgroundImage:
                  AssetImage('assets/profiles/$_selectedProfileIndex.png'),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 19,
                itemBuilder: (context, index) {
                  int profileIndex = index + 1; // Image names from 1 to 19
                  return GestureDetector(
                    onTap: () => _selectProfile(profileIndex),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/profiles/$profileIndex.png'),
                      radius: 30,
                      child: _selectedProfileIndex == profileIndex
                          ? const Icon(Icons.check_circle,
                              color: Colors.blue, size: 30)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            width: screenWidth / 2.5,
            height: screenHeight / 10,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: darkerertheme),
              onPressed: () async {
                await getName();
                saveDetailsInFire(_selectedProfileIndex);
                if (mounted) {
                  // Ensure widget is still mounted before using context
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Wrapper()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: const Text(
                'Confirm',
                style: TextStyle(
                    color: white, fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
