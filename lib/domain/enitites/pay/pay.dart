import 'package:freezed_annotation/freezed_annotation.dart';
part 'pay.freezed.dart';

@freezed
class Pay with _$Pay{
  const factory Pay({
    required String id , 
    required String uuid, 
    required String name,
    required int lendAmount, 
    required int loanAmount, 
  })= _Pay;
}