import 'package:comments_app/authentication/controller/authentication_controller.dart';
import 'package:comments_app/widgets/custom_snackbar.dart'; // Import CustomSnackbar
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication {
  Authentication.init();
  static Authentication instance = Authentication.init();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> loginWithEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      final UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (err) {
      debugPrint(err.message);
      debugPrint(err.code);

      if (err.code == "user-not-found") {
        CustomSnackbar.showSnackbar(
            context, "User doesn't exist with the provided email");
        return null;
      }
      if (err.code == "invalid-email") {
        CustomSnackbar.showSnackbar(context, "Provided email is invalid");
        return null;
      }
      if (err.code == "invalid-credential") {
        CustomSnackbar.showSnackbar(
            context, "Invalid credentials or account doesn't exist");
        return null;
      }
      if (err.code == "wrong-password") {
        CustomSnackbar.showSnackbar(context, "Password incorrect");
        return null;
      }
      if (err.code == "user-disabled") {
        CustomSnackbar.showSnackbar(context, "Your account has been disabled");
        return null;
      }
    }
    return null;
  }

  Future<User?> createUser(
      {required String email,
      required String password,
      required BuildContext context,
      required AuthController authController}) async {
    try {
      authController.updateIsRegistering(isRegistering: true);
      final UserCredential credential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (err) {
      authController.updateIsRegistering(isRegistering: false);

      if (err.code == "email-already-in-use") {
        CustomSnackbar.showSnackbar(
            context, "User already exists with the provided email");
        return null;
      }
      if (err.code == "invalid-email") {
        CustomSnackbar.showSnackbar(context, "Provided email is invalid");
        return null;
      }
      if (err.code == "weak-password") {
        CustomSnackbar.showSnackbar(context, "Password is weak");
        return null;
      }
    }
    return null;
  }
}
