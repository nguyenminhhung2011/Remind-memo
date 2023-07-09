import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project/core/extensions/int_extension.dart';

import '../../../domain/enitites/transaction/transaction.dart';

part 'transaction_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TransactionModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'price')
  final int price;
  @JsonKey(name: 'createTime')
  final int createTime;
  @JsonKey(name: 'note')
  final String note;
  @JsonKey(name: 'contactId')
  final String contactId;
  @JsonKey(name: 'notificationTime')
  final int notificationTime;
  @JsonKey(name: 'type')
  final int type;

  TransactionModel(
    this.id,
    this.note,
    this.type,
    this.price,
    this.createTime,
    this.contactId,
    this.notificationTime,
  );

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  TransactionEntity get toEntity => TransactionEntity(
        id: id,
        price: price,
        note: note,
        createTime: DateTime.fromMillisecondsSinceEpoch(createTime),
        notificationTIme: DateTime.fromMillisecondsSinceEpoch(notificationTime),
        type: type.toTransactionType,
        contactId: contactId,
      );
}
