import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';
import 'package:project/domain/enitites/transaction/transaction.dart';

import '../../../domain/enitites/contact/contact.dart';

@injectable
class ContactDetailNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;
  final String _contactId;
  String get contactId => _contactId;
  ContactDetailNotifier(
    @factoryParam String contactId,
    this._firebaseRepository,
  ) : _contactId = contactId;

  Contact? _contact;
  Contact? get contact => _contact;

  List<TransactionEntity> _listTransaction = <TransactionEntity>[];
  List<TransactionEntity> get listTransaction => _listTransaction;

  bool _loadingGet = false;
  bool get loadingGet => _loadingGet;
  bool _loadingGet1 = false;
  bool get loadingGet1 => _loadingGet;

  FutureOr<void> getContactAndSetPay(String pId) async {
    _loadingGet = true;
    notifyListeners();
    final get = await _firebaseRepository.getContactById(_contactId, pId);
    if (get != null) {
      log(get.name);
      _contact = get;
      notifyListeners();
    }
    _loadingGet = false;
    notifyListeners();
  }

  FutureOr<void> getTransactions(String paidId) async {
    _loadingGet1 = true;
    notifyListeners();
    try {
      final streamTransactions =
          _firebaseRepository.getTransactions(paidId, _contactId);
      streamTransactions.listen((event) {
        _listTransaction = event;
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
    _loadingGet1 = false;
    notifyListeners();
  }

  void setContact(Contact newContact){
    _contact = newContact;
    notifyListeners();
  }
}
