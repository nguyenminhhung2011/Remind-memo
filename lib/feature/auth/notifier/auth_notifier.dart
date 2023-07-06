import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';

@injectable
class AuthNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;

  AuthNotifier(this._firebaseRepository);

  Future<bool> checkingAuthentication() async {
    return true;
  }

  Future<void> onGoogleAuth() async => await _firebaseRepository.googleAuth();
}
