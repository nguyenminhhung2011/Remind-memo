import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';
import 'package:project/domain/enitites/transaction/transaction.dart';

import '../../../domain/enitites/contact/contact.dart';

class AddPayArguments {
  final String contactId;
  final bool loan;
  AddPayArguments({
    required this.contactId,
    required this.loan,
  });
}

@injectable
class AddPayNotifier extends ChangeNotifier {
  final String _contactId;
  final bool _loan;
  final FirebaseRepository _firebaseRepository;
  AddPayNotifier(
    @factoryParam AddPayArguments arguments,
    this._firebaseRepository,
  )   : _contactId = arguments.contactId,
        _loan = arguments.loan,
        super() {}
  String get contactId => _contactId;
  bool get loan => _loan;
  bool _load = false;
  bool get load => _load;
  bool _loadGet = false;
  bool get loadGet => _loadGet;

  Contact? _contact;
  Contact? get contact => _contact;

  FutureOr<void> getContact(String paidId) async {
    _loadGet = true;
    notifyListeners();
    try {
      final result = await _firebaseRepository.getContactById(_contactId, paidId);
      _contact = result;
    } catch (e) {
      log(e.toString());
    }
    _loadGet = false;
    notifyListeners();
   }

  FutureOr<bool> addTransaction(
      TransactionEntity transaction, String paidId) async {
    _load = true;
    notifyListeners();
    try {
      await _firebaseRepository.addTransaction(transaction, paidId);
      return true;
    } catch (e) {
      log(e.toString());
    }
    _load = false;
    notifyListeners();
    return false;
  }
}
