import 'package:wordle/Services/Player.dart';
import 'package:flutter/material.dart';
import 'package:wordle/Services/providers/instances.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class UserDetailsProvider extends ChangeNotifier {
  profileUser? userDetails;
  int check = 0;
  SharedPreferences? prefs;
  final user = FirebaseAuth.instance.currentUser;

  UserDetailsProvider() {
    if (user != null) {
      initializePrefs();
      getUserDetails();
    }
  }

  Future<void> getUserDetails() async {
    print("Getting user details from provider");
    await initializePrefs();
    Map userData = await getDataFromCache();
    print("Successfully got data frm cache");

    if (userData.isNotEmpty) {
      print("userData is not empty");
      userDetails = profileUser(
          username: userData['name'],
          email: userData['email'],
          score: userData['score'],
          pfp: userData['pfp']);

      check = 1;
    } else {
      print("userdata is empty");
      userDetails = await Instances.userRef.getUserDetails();
      print("got data from frebase");
      print(userDetails);
      await saveMapToSharedPreferences(userDetails!.toMap());
      check = 1;
    }
    notifyListeners(); // Notify listeners when `userDetails` changes
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  Future<Map<String, dynamic>> getDataFromCache() async {
    print("Started getting string");
    String? jsonString = prefs!.getString('userData');
    print("finished getting string");
    if (jsonString == null) {
      return {};
    }
    return json.decode(jsonString); // Convert JSON String back to Map
  }

  Future<void> saveMapToSharedPreferences(Map<String, dynamic> data) async {
    String jsonString = json.encode(data);
    await prefs!.setString('userData', jsonString); // Save JSON String
  }

//
//

  Future<void> updateTheScore(int score) async {
    await Instances.userRef.updateScore(score);

    profileUser? updatedUserDetails = await Instances.userRef.getUserDetails();

    userDetails = updatedUserDetails;

    Map<String, dynamic> updatedData = updatedUserDetails!.toMap();
    await saveMapToSharedPreferences(updatedData);

    notifyListeners();
  }
}
