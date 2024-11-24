import 'package:wordle/model/Player.dart';
import 'package:flutter/material.dart';
import 'package:wordle/model/providers/instances.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class UserDetailsProvider extends ChangeNotifier {
  profileUser? userDetails;
  int check = 0;
  SharedPreferences? prefs;
  final user = FirebaseAuth.instance.currentUser;

  UserDetailsProvider() {
    initializePrefs();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    Map userData = await getDataFromCache();
    if (userData != null) {
      userDetails = profileUser(
          username: userData['name'],
          email: userData['email'],
          score: userData['score'],
          pfp: userData['pfp']);
      check = 1;
    } else {
      userDetails = await Instances.userRef.getUserDetails();
      check = 1;
    }

    notifyListeners(); // Notify listeners when `userDetails` changes
  }

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    notifyListeners();
  }

  Future<void> getAndCacheInfo() async {
    if (prefs == null) await initializePrefs();
    await getDataFromCache();
    notifyListeners();
  }

  Future<Map<String, dynamic>> getDataFromCache() async {
    String? jsonString = prefs!.getString('userData');
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
}
