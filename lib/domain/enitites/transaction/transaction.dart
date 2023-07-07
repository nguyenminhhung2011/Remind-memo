import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/type.dart';
part 'transaction.freezed.dart';

@freezed 
class Transaction with _$Transaction {
  const factory Transaction({
    required String id, 
    required int price, 
    required String note, 
    required DateTime createTime, 
    required DateTime notificationTIme, 
    required TypeTransaction type,  
  }) = _Transaction;
}