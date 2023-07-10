import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';
import 'package:project/domain/enitites/transaction/transaction.dart';

import '../../../domain/enitites/contact/contact.dart';

class Step {
  Step(this.name, this.id, this.price, this.isPay, this.count,
      [this.isExpanded = false]);
  String name;
  String id;
  int price;
  bool isPay;
  int count;
  bool isExpanded;
}

@injectable
class ContactNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;
  ContactNotifier(this._firebaseRepository);

  List<Contact> _listContact = <Contact>[];
  List<Contact> get listContact => _listContact;
  Map<String, Contact> _mapContacts = {};
  Map<String, Contact> get mapContacts => _mapContacts;

  Map<String, List<TransactionEntity>> _mapTransactions = {};
  Map<String, List<TransactionEntity>> get mapTransactions => _mapTransactions;

  bool _loadingGet = false;
  bool get loadingGet => _loadingGet;
  bool _loadingGet1 = false;
  bool get loadingGet1 => _loadingGet1;
  bool _loadingButton = false;
  bool get loadingButton => _loadingButton;

  bool _loadingTransactions = false;
  bool get loadingTransactions => _loadingTransactions;
  String _loadingId = '';
  String get loadingId => _loadingId;

  List<Step> _listStep = [];
  List<Step> get listStep => _listStep;

  void onSelectStep(int index, bool isExpanded) {
    _listStep[index].isExpanded = !isExpanded;
    if (isExpanded) {}
    notifyListeners();
  }

  Future<void> getTransactions(String paidId, String contactId) async {
    _loadingId = contactId;
    _loadingTransactions = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      final streamTransactions = _firebaseRepository
          .getTransactions(paidId, contactId, isFormatDate: true);
      streamTransactions.listen((event) {
        if (_mapTransactions.containsKey(contactId)) {
          _mapTransactions[contactId] = <TransactionEntity>[];
        } else {
          _mapTransactions.addAll({contactId: <TransactionEntity>[]});
        }
        _mapTransactions[contactId] =  event;
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
    _loadingId = '';
    _loadingTransactions = false;
    notifyListeners();
  }

  Future<void> getContacts(String paidId) async {
    _loadingGet = true;
    notifyListeners();
    try {
      final streamContacts = _firebaseRepository.getContacts(paidId);
      streamContacts.listen((event) {
        _listContact = event;
        _listStep = event
            .map((e) => Step(e.name, e.id, e.price, e.price >= 0, e.count))
            .toList();
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
    _loadingGet = false;
    notifyListeners();
  }

  Future<void> getMapContacts(String paidId) async {
    _loadingGet1 = true;
    notifyListeners();
    try {
      final streamContacts = _firebaseRepository.getContacts(paidId);
      streamContacts.listen((event) {
        _mapContacts = {};
        for (var element in event) {
          if (!_mapContacts.containsKey(element.id)) {
            _mapContacts.addAll({element.id: element});
          }
        }
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
    _loadingGet1 = false;
    notifyListeners();
  }

  Future<bool> addContact(Contact contact, String paidId) async {
    _loadingButton = true;
    notifyListeners();
    try {
      await _firebaseRepository.addContact(contact, paidId);
    } catch (e) {
      log(e.toString());
      _loadingButton = false;
      return false;
    }
    _loadingButton = false;
    notifyListeners();
    return true;
  }

  Future<void> updateContact(Contact newContact, String paidId) async {
    try {
      final add = await _firebaseRepository.updateContact(newContact, paidId);
      if (add == null) {
        log("Error");
        return;
      }
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }
}
