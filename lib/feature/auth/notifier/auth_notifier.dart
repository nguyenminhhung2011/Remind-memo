import 'package:flutter/material.dart';

class AuthNotifier extends ChangeNotifier{
  AuthNotifier();

  Future<bool> checkingAuthentication()async {
    return true;
  }

}