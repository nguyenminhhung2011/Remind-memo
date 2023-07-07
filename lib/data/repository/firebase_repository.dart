import 'package:project/domain/enitites/user_entity.dart';

abstract class FirebaseRepository{
  Future<void> googleAuth();
  Future<void> signUp(UserEntity userEntity);
  Future<void> signIn(UserEntity userEntity);
  Future<UserEntity?> getCurrentUser(UserEntity userEntity);
  Future<bool> isSignIn();
  Future<String> getCurrentUUid();
  Future<UserEntity?> getUserByUuid();
}