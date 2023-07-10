import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';
import 'package:project/domain/enitites/transaction/transaction.dart';

@injectable
class HomeNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;
  HomeNotifier(this._firebaseRepository);

  Map<DateTime, List<TransactionEntity>> _listTransaction = {};
  Map<DateTime, List<TransactionEntity>> get listTransaction =>
      _listTransaction;

  bool _loadingGet = false;
  bool get loadingGet => _loadingGet;

  FutureOr<void> getTransactions(String paidId, int type) async {
    _loadingGet = true;
    notifyListeners();
    try {
      final streamTransactions =
          _firebaseRepository.getAllTransactions(paidId, type);
      streamTransactions.listen((event) {
        _listTransaction = {};
        for (var element in event) {
          final createTime = element.createTime;
          final timeKey =
              DateTime(createTime.year, createTime.month, createTime.day);
          if (_listTransaction.containsKey(timeKey)) {
            _listTransaction[timeKey]!.add(element);
          } else {
            _listTransaction.addAll({
              timeKey: [element]
            });
          }
        }
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
    _loadingGet = false;
    notifyListeners();
  }
}
