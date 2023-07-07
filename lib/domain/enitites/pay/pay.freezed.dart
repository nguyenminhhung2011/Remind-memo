// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pay.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Pay {
  String get id => throw _privateConstructorUsedError;
  String get uuid => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get lendAmount => throw _privateConstructorUsedError;
  int get loanAmount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PayCopyWith<Pay> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PayCopyWith<$Res> {
  factory $PayCopyWith(Pay value, $Res Function(Pay) then) =
      _$PayCopyWithImpl<$Res, Pay>;
  @useResult
  $Res call(
      {String id, String uuid, String name, int lendAmount, int loanAmount});
}

/// @nodoc
class _$PayCopyWithImpl<$Res, $Val extends Pay> implements $PayCopyWith<$Res> {
  _$PayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? name = null,
    Object? lendAmount = null,
    Object? loanAmount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lendAmount: null == lendAmount
          ? _value.lendAmount
          : lendAmount // ignore: cast_nullable_to_non_nullable
              as int,
      loanAmount: null == loanAmount
          ? _value.loanAmount
          : loanAmount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PayCopyWith<$Res> implements $PayCopyWith<$Res> {
  factory _$$_PayCopyWith(_$_Pay value, $Res Function(_$_Pay) then) =
      __$$_PayCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String uuid, String name, int lendAmount, int loanAmount});
}

/// @nodoc
class __$$_PayCopyWithImpl<$Res> extends _$PayCopyWithImpl<$Res, _$_Pay>
    implements _$$_PayCopyWith<$Res> {
  __$$_PayCopyWithImpl(_$_Pay _value, $Res Function(_$_Pay) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? uuid = null,
    Object? name = null,
    Object? lendAmount = null,
    Object? loanAmount = null,
  }) {
    return _then(_$_Pay(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uuid: null == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lendAmount: null == lendAmount
          ? _value.lendAmount
          : lendAmount // ignore: cast_nullable_to_non_nullable
              as int,
      loanAmount: null == loanAmount
          ? _value.loanAmount
          : loanAmount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_Pay implements _Pay {
  const _$_Pay(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.lendAmount,
      required this.loanAmount});

  @override
  final String id;
  @override
  final String uuid;
  @override
  final String name;
  @override
  final int lendAmount;
  @override
  final int loanAmount;

  @override
  String toString() {
    return 'Pay(id: $id, uuid: $uuid, name: $name, lendAmount: $lendAmount, loanAmount: $loanAmount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Pay &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lendAmount, lendAmount) ||
                other.lendAmount == lendAmount) &&
            (identical(other.loanAmount, loanAmount) ||
                other.loanAmount == loanAmount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, uuid, name, lendAmount, loanAmount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PayCopyWith<_$_Pay> get copyWith =>
      __$$_PayCopyWithImpl<_$_Pay>(this, _$identity);
}

abstract class _Pay implements Pay {
  const factory _Pay(
      {required final String id,
      required final String uuid,
      required final String name,
      required final int lendAmount,
      required final int loanAmount}) = _$_Pay;

  @override
  String get id;
  @override
  String get uuid;
  @override
  String get name;
  @override
  int get lendAmount;
  @override
  int get loanAmount;
  @override
  @JsonKey(ignore: true)
  _$$_PayCopyWith<_$_Pay> get copyWith => throw _privateConstructorUsedError;
}
