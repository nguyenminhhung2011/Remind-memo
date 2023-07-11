import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';

class GroupData {
  int lend;
  int loan;
  GroupData({required this.lend, required this.loan});
}

@injectable
class ChartNotifier extends ChangeNotifier {
  final FirebaseRepository _firebaseRepository;
  ChartNotifier(this._firebaseRepository);

  DateTime _timeStart = DateTime.now();
  DateTime _timeEnd = DateTime.now();
  DateTime get timeStart => _timeStart;
  DateTime get timeEnd => _timeEnd;

  int _maxColumnData = 0;
  int get maxColumnData => _maxColumnData;

  Map<DateTime, GroupData> _columnData = {};
  Map<DateTime, GroupData> get columnData => _columnData;

  Map<String, int> _lendCircleData = {};
  Map<String, int> get lendCircleData => _lendCircleData;
  int _lendSummary = 0;
  int get lendSummary => _lendSummary;

  Map<String, int> _loanCircleData = {};
  Map<String, int> get loanCircleData => _loanCircleData;
  int _loanSummary = 0;
  int get loanSummary => _loanSummary;

  FutureOr<void> getData(List<DateTime> listDate, String paidId) {
    _timeStart = listDate.first.copyWith(hour: 0, minute: 0, second: 0);
    _timeEnd = listDate.last.copyWith(hour: 23, minute: 59, second: 59);
    notifyListeners();
    try {
      final streamTransactions =
          _firebaseRepository.getTransactionsFromRangeDates(
        _timeStart.millisecondsSinceEpoch,
        _timeEnd.millisecondsSinceEpoch,
        paidId,
      );
      streamTransactions.listen((event) {
        _columnData = {};
        _lendCircleData = {};
        _loanCircleData = {};
        _maxColumnData = 0;
        _lendSummary = 0;
        _loanSummary = 0;

        for (var element in listDate) {
          final timeKey = DateTime(element.year, element.month, element.day);
          _columnData.addAll({
            timeKey: GroupData(lend: 0, loan: 0),
          });
        }
        for (var element in event) {
          final createTime = element.createTime;
          final timeKey =
              DateTime(createTime.year, createTime.month, createTime.day);
          if (element.type.isLend) {
            _lendCircleData.containsKey(element.contactId)
                ? _lendCircleData[element.contactId] =
                    _lendCircleData[element.contactId]! + element.price
                : _lendCircleData.addAll({element.contactId: element.price});
            _columnData[timeKey]!.lend += element.price;
            _lendSummary += element.price;
          } else {
            _loanCircleData.containsKey(element.contactId)
                ? _loanCircleData[element.contactId] =
                    _loanCircleData[element.contactId]! + element.price
                : _loanCircleData.addAll({element.contactId: element.price});
            _columnData[timeKey]!.loan += element.price;
            _loanSummary += element.price;
          }
        }
        _maxColumnData = max(_lendSummary, _loanSummary);
        notifyListeners();
      });
      notifyListeners();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}
