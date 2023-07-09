// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TransactionEntity {
  String get id => throw _privateConstructorUsedError;
  int get price => throw _privateConstructorUsedError;
  String get contactId => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  DateTime get createTime => throw _privateConstructorUsedError;
  DateTime get notificationTIme => throw _privateConstructorUsedError;
  TypeTransaction get type => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TransactionEntityCopyWith<TransactionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionEntityCopyWith<$Res> {
  factory $TransactionEntityCopyWith(
          TransactionEntity value, $Res Function(TransactionEntity) then) =
      _$TransactionEntityCopyWithImpl<$Res, TransactionEntity>;
  @useResult
  $Res call(
      {String id,
      int price,
      String contactId,
      String note,
      DateTime createTime,
      DateTime notificationTIme,
      TypeTransaction type});
}

/// @nodoc
class _$TransactionEntityCopyWithImpl<$Res, $Val extends TransactionEntity>
    implements $TransactionEntityCopyWith<$Res> {
  _$TransactionEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? contactId = null,
    Object? note = null,
    Object? createTime = null,
    Object? notificationTIme = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notificationTIme: null == notificationTIme
          ? _value.notificationTIme
          : notificationTIme // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TypeTransaction,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TransactionEntityCopyWith<$Res>
    implements $TransactionEntityCopyWith<$Res> {
  factory _$$_TransactionEntityCopyWith(_$_TransactionEntity value,
          $Res Function(_$_TransactionEntity) then) =
      __$$_TransactionEntityCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int price,
      String contactId,
      String note,
      DateTime createTime,
      DateTime notificationTIme,
      TypeTransaction type});
}

/// @nodoc
class __$$_TransactionEntityCopyWithImpl<$Res>
    extends _$TransactionEntityCopyWithImpl<$Res, _$_TransactionEntity>
    implements _$$_TransactionEntityCopyWith<$Res> {
  __$$_TransactionEntityCopyWithImpl(
      _$_TransactionEntity _value, $Res Function(_$_TransactionEntity) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? price = null,
    Object? contactId = null,
    Object? note = null,
    Object? createTime = null,
    Object? notificationTIme = null,
    Object? type = null,
  }) {
    return _then(_$_TransactionEntity(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int,
      contactId: null == contactId
          ? _value.contactId
          : contactId // ignore: cast_nullable_to_non_nullable
              as String,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      createTime: null == createTime
          ? _value.createTime
          : createTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      notificationTIme: null == notificationTIme
          ? _value.notificationTIme
          : notificationTIme // ignore: cast_nullable_to_non_nullable
              as DateTime,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TypeTransaction,
    ));
  }
}

/// @nodoc

class _$_TransactionEntity implements _TransactionEntity {
  const _$_TransactionEntity(
      {required this.id,
      required this.price,
      required this.contactId,
      required this.note,
      required this.createTime,
      required this.notificationTIme,
      required this.type});

  @override
  final String id;
  @override
  final int price;
  @override
  final String contactId;
  @override
  final String note;
  @override
  final DateTime createTime;
  @override
  final DateTime notificationTIme;
  @override
  final TypeTransaction type;

  @override
  String toString() {
    return 'TransactionEntity(id: $id, price: $price, contactId: $contactId, note: $note, createTime: $createTime, notificationTIme: $notificationTIme, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TransactionEntity &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.contactId, contactId) ||
                other.contactId == contactId) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.notificationTIme, notificationTIme) ||
                other.notificationTIme == notificationTIme) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, price, contactId, note,
      createTime, notificationTIme, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TransactionEntityCopyWith<_$_TransactionEntity> get copyWith =>
      __$$_TransactionEntityCopyWithImpl<_$_TransactionEntity>(
          this, _$identity);
}

abstract class _TransactionEntity implements TransactionEntity {
  const factory _TransactionEntity(
      {required final String id,
      required final int price,
      required final String contactId,
      required final String note,
      required final DateTime createTime,
      required final DateTime notificationTIme,
      required final TypeTransaction type}) = _$_TransactionEntity;

  @override
  String get id;
  @override
  int get price;
  @override
  String get contactId;
  @override
  String get note;
  @override
  DateTime get createTime;
  @override
  DateTime get notificationTIme;
  @override
  TypeTransaction get type;
  @override
  @JsonKey(ignore: true)
  _$$_TransactionEntityCopyWith<_$_TransactionEntity> get copyWith =>
      throw _privateConstructorUsedError;
}
