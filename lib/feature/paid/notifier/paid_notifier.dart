import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repository/firebase_repository.dart';
import '../../../domain/enitites/pay/pay.dart';

@injectable
class PaidNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;
  PaidNotifier(this._firebaseRepository) {}

  List<Pay> _listPay = <Pay>[];
  List<Pay> get listPay => _listPay;

  Pay? _pay;
  Pay? get pay => _pay;

  bool _loadingGet = false;
  bool get loadingGet => _loadingGet;
  bool _loadingButton = false;
  bool get loadingButton => _loadingButton;

  Future<void> getPays() async {
    _loadingGet = true;
    notifyListeners();
    try {
      final streamPays = _firebaseRepository.getPays();
      streamPays.listen((event) {
        if (event.isNotEmpty) {
          _pay = event.first;
        }
        _listPay = event;
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
    _loadingGet = false;
    notifyListeners();
  }

  Future<bool> addNewPaid(String name, String uid) async {
    _loadingButton = true;
    notifyListeners();
    try {
      final streamPays = _firebaseRepository.addPay(Pay(
        id: '',
        uuid: uid,
        name: name,
        lendAmount: 0,
        loanAmount: 0,
      ));
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
    _loadingButton = false;
    notifyListeners();
    return true;
  }

  FutureOr<void> setPaid(Pay pay) {
    _pay = pay;
    notifyListeners();
  }

  FutureOr<void> getPayAndSetPay(String id) async {
    final get = await _firebaseRepository.getPayById(id);
    if (get != null) {
      log(get.name);
      _pay = get;
      notifyListeners();
    }
  }
  
}
