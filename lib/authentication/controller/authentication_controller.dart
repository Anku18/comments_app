import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  bool isRegistering = false;
  bool isLogingIn = false;

  void updateIsRegistering({required isRegistering}) {
    this.isRegistering = isRegistering;
    notifyListeners();
  }

  void updateIsLogginIn({required isLogingIn}) {
    this.isLogingIn = isLogingIn;
    notifyListeners();
  }
}
