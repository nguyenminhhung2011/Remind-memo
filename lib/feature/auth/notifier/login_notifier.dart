import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';
import 'package:project/domain/enitites/user_entity.dart';

@injectable
class LoginNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;

  LoginNotifier(this._firebaseRepository);

  bool _loadingSignUp = false;
  bool get loadingSignUp => _loadingSignUp;

  Future<void> onGoogleAuth() async => await _firebaseRepository.googleAuth();
  Future<bool> onSignIn(UserEntity userEntity) async {
    _loadingSignUp = true;
    notifyListeners();
    try {
      await _firebaseRepository.signIn(userEntity);
      return true;
    } catch (e) {
      log(e.toString());
    }
    _loadingSignUp = false;
    notifyListeners();
    return false;
  }

  Future<UserEntity?> getCurrentUser() async =>
      await _firebaseRepository.getUserByUuid();
      
}
