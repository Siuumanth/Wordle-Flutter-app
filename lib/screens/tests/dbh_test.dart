import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'CRUD.dart';
import 'dart:developer';

class DatabaseService {
  final _fire = FirebaseFirestore.instance;

  create(User user) {
    try {
      _fire.collection("users").add(user.toMap());
    } catch (e) {
      print(e.toString());
    }
  }
}
