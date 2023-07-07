import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/enitites/pay/pay.dart';
part 'pay_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PayModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'uuid')
  final String uuid;
  @JsonKey(name: 'lendAmount')
  final int lendAmount;
  @JsonKey(name: 'loanAmount')
  final int loanAmount;

  PayModel(
    this.id,
    this.name,
    this.uuid,
    this.lendAmount,
    this.loanAmount,
  );

  Map<String, dynamic> toJson() => _$PayModelToJson(this);
  factory PayModel.fromJson(Map<String, dynamic> json) =>
      _$PayModelFromJson(json);
  Pay get toEntity => Pay(
        id: id,
        uuid: uuid,
        name: name,
        lendAmount: lendAmount,
        loanAmount: loanAmount,
      );
}
