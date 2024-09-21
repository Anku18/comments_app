import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseDb {
  FirebaseDb.init();
  static final FirebaseDb instance = FirebaseDb.init();

  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<String?> addUserToDb({required Map<String, dynamic> body}) async {
    try {
      DocumentReference<Map<String, dynamic>> doc =
          await firebaseFirestore.collection("Users").add(body);
      return doc.id;
    } on FirebaseException catch (e) {
      print("HERE///////////////////////////////////////ERROR");
      print(e.toString());
      debugPrint(e.toString());
      return null;
    }
  }
}
