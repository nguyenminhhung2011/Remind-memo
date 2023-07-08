import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/enitites/contact/contact.dart';
part 'contact_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ContactModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;
  @JsonKey(name: 'note')
  final String note;
  @JsonKey(name: 'type')
  final int type;
  @JsonKey(name: 'count')
  final int count;
  @JsonKey(name: 'price')
  final int price;

  ContactModel(
    this.id,
    this.name,
    this.phoneNumber,
    this.note,
    this.type,
    this.count,
    this.price,
  );

  Map<String, dynamic> toJson() => _$ContactModelToJson(this);
  factory ContactModel.fromJson(Map<String, dynamic> json) =>
      _$ContactModelFromJson(json);

  Contact get toEntity => Contact(
        id: id,
        name: name,
        phoneNumber: phoneNumber,
        note: note,
        type: type,
        count: count,
        price: price,
      );
}
