import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

class AddPayArguments {
  final int contactId;
  final bool loan;
  AddPayArguments({
    required this.contactId,
    required this.loan,
  });
}

class AddPayNotifier extends ChangeNotifier {
  final int _contactId;
  final bool _loan;
  AddPayNotifier(
    @factoryParam AddPayArguments arguments,
  )   : _contactId = arguments.contactId,
        _loan = arguments.loan,
        super() {}
  int get contactId => _contactId;
  bool get loan => _loan;
}
