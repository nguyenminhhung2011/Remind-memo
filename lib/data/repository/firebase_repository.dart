import 'package:project/domain/enitites/user_entity.dart';

import '../../domain/enitites/pay/pay.dart';

abstract class FirebaseRepository{
  Future<void> googleAuth();
  Future<void> signUp(UserEntity userEntity);
  Future<void> signIn(UserEntity userEntity);
  Future<Pay> addPay(Pay pay);
  Future<UserEntity?> getCurrentUser(UserEntity userEntity);
  Future<bool> isSignIn();
  Future<String> getCurrentUUid();
  Future<UserEntity?> getUserByUuid();
  Stream<List<Pay>> getPays();
}