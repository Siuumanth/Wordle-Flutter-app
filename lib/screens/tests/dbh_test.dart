import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'CRUD.dart';

class DatabaseService {
  final _fire = FirebaseFirestore.instance;
  final _real = FirebaseDatabase.instance;

  rlcreate(User user) {
    try {
      _real.ref("users").child("user2").set(user.toMap());
    } catch (e) {
      print(e.toString());
    }
  }

  rlRead() async {
    try {
      final data = await _real.ref("users").once();

      for (int i = 0; i < data.snapshot.children.length; i++) {
        print(data.snapshot.children.toList()[i].value.toString());
        print("----------\n");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  rlUpdate() async {
    try {
      await _real.ref("users").child("user1").update({"name": "chubs_3d"});
    } catch (e) {}
  }

  rlDelete() async {
    try {
      await _real.ref("users").child("user2").remove();
    } catch (e) {}
  }

  create(User user) {
    try {
      _fire.collection("users").add(user.toMap());
    } catch (e) {
      print(e.toString());
    }
  }
}
