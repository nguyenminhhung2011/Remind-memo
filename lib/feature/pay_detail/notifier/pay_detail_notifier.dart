import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';
import 'package:project/domain/enitites/transaction/transaction.dart';

import '../../../domain/enitites/contact/contact.dart';

@injectable
class PayDetailNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;
  final String _transactionId;
  final String _contactId;

  String get transactionId => _transactionId;
  String get contactId => _contactId;

  PayDetailNotifier(
    @factoryParam String transactionId,
    @factoryParam String contactId,
    this._firebaseRepository,
  )   : _contactId = contactId,
        _transactionId = transactionId;

  TransactionEntity? _transaction;
  TransactionEntity? get transaction => _transaction;

  Contact? _contact;
  Contact? get contact => _contact;

  bool _loading = false;
  bool get loading => _loading;

  bool _loadingButton = false;
  bool get loadingButton => _loadingButton;

  FutureOr<void> getTransactionDetail(String paidId) async {
    _loading = true;
    notifyListeners();
    try {
      final get =
          await _firebaseRepository.getTransactionById(_transactionId, paidId);
      if (get == null) {
        log('Error');
      }
      _transaction = get;
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
    _loading = false;
    notifyListeners();
  }

  Future<bool> updateTransactions(
      TransactionEntity newTransaction, String paidId) async {
    _loadingButton = true;
    notifyListeners();
    try {
      final result =
          await _firebaseRepository.updateTransaction(newTransaction, paidId);
      _loadingButton = false;
      notifyListeners();
      return result != null;
    } catch (e) {
      log(e.toString());
    }
    _loadingButton = false;
    notifyListeners();
    return false;
  }

  Future<bool> deleteTransaction(String transactionId, String paidId) async =>
      await _firebaseRepository.deleteTransaction(paidId, transactionId);
}
