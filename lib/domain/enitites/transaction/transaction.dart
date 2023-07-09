import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enum/type.dart';
part 'transaction.freezed.dart';

@freezed 
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id, 
    required int price, 
    required String contactId,
    required String note, 
    required DateTime createTime, 
    required DateTime notificationTIme, 
    required TypeTransaction type,  
  }) = _TransactionEntity;
}