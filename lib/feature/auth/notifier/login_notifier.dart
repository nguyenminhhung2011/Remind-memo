import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';

@injectable
class LoginNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;

  LoginNotifier(this._firebaseRepository);



  Future<void> onGoogleAuth() async => await _firebaseRepository.googleAuth();
}
