import 'package:intl/intl.dart';
import 'package:project/core/enum/type.dart';

extension IntExtension on int {
  TypeTransaction get toTransactionType =>
      switch (this) { 0 => TypeTransaction.lend, _ => TypeTransaction.loan };

  String get price => NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(this);
}
