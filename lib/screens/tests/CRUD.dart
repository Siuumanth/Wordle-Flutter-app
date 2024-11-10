// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dbh_test.dart';

class User {
  String name;
  String email;
  String phone;

  // Custom constructor for creating a User instance
  User({required this.name, required this.email, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }
}

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final dbService = DatabaseService();

  @override
  void dispose() {
    // Dispose of the controllers when no longer needed
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Example methods for CRUD actions
  void _createUser() {
    final user = User(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text);
    dbService.rlcreate(user);
    print(
        "\n\n\n\n Create: Name - ${_nameController.text}, Email - ${_emailController.text}, Phone - ${_phoneController.text}");
  }

  void _readUser() {
    dbService.rlRead();
    print("Read: Display user data");
  }

  void _updateUser() {
    dbService.rlUpdate();
    print("Update: Update user data");
  }

  void _deleteUser() {
    dbService.rlDelete();
    print("Delete: User deleted");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Realtime Database')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _createUser,
                  child: const Text('Create'),
                ),
                ElevatedButton(
                  onPressed: _readUser,
                  child: const Text('Read'),
                ),
                ElevatedButton(
                  onPressed: _updateUser,
                  child: const Text('Update'),
                ),
                ElevatedButton(
                  onPressed: _deleteUser,
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
