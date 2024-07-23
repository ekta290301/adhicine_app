import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Db {
  CollectionReference users1 = FirebaseFirestore.instance.collection('users1');

  Future<void> addUser(Map<String, dynamic> data, BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await users1
        .doc(userId)
        .set(data)
        .then((value) => print("User Added"))
        .catchError((error) {
      _showErrorDialog(context, error.toString());
    });
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign up Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
