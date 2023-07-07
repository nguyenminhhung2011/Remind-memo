import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';
import 'package:project/domain/enitites/user_entity.dart';

@injectable
class RegisterNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;

  RegisterNotifier(this._firebaseRepository);

  Future<void> onGoogleAuth() async => await _firebaseRepository.googleAuth();

  bool _loadingSignUp = false;
  bool get loadingSignUp => _loadingSignUp;

  Future<bool> onSignUp(UserEntity userEntity) async {
    _loadingSignUp = true;
    notifyListeners();
    try {
      await _firebaseRepository.signUp(userEntity);
      return true;
    } catch (e) {
      log(e.toString());
    }
    _loadingSignUp = false;
    notifyListeners();
    return false;
  }

  Future<bool> getCurrentUserAfterCreate(UserEntity user) async {
    _loadingSignUp = true;
    notifyListeners();
    try {
      await _firebaseRepository.getCurrentUser(user);
      return true;
    } catch (e) {
      log(e.toString());
    }
    _loadingSignUp = false;
    notifyListeners();
    return false;
  }
}
