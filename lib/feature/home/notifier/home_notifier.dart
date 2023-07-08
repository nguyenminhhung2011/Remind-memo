import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';

@injectable
class HomeNotifier extends ChangeNotifier{
  final FirebaseRepository _firebaseRepository;
  HomeNotifier(this._firebaseRepository);
}