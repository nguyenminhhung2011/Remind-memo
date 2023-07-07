import 'package:project/core/enum/type.dart';

extension IntExtension on int {
  TypeTransaction get toTransactionType =>
      switch (this) { 0 => TypeTransaction.lend, _ => TypeTransaction.loan };
}
