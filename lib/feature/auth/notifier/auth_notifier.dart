import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/data_source/preferences.dart';
import 'package:project/data/repository/firebase_repository.dart';
import 'package:project/domain/enitites/user_entity.dart';

@injectable
class AuthNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;

  AuthNotifier(this._firebaseRepository);

  UserEntity _user = UserEntity();
  UserEntity get user => _user;

  void setUser(UserEntity user) {
    _user = user;
  }

  Future<bool> checkingAuthentication() async {
    try {
      return await _firebaseRepository.isSignIn();
    } catch (_) {}
    return false;
  }

  Future<bool> getAndSetUser() async {
    try {
      final newUser = await _firebaseRepository.getUserByUuid();
      if (newUser == null) {
        return false;
      }
      setUser(newUser);
      return true;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<void> onGoogleAuth() async => await _firebaseRepository.googleAuth();

  Future<void> onSignOut() async {
    await _firebaseRepository.signOut();
    CommonAppSettingPref.removePayId();
  }
}
