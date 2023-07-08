import 'package:project/domain/enitites/user_entity.dart';

import '../../domain/enitites/contact/contact.dart';
import '../../domain/enitites/pay/pay.dart';

abstract class FirebaseRepository{
  Future<void> googleAuth();
  Future<void> signUp(UserEntity userEntity);
  Future<void> signIn(UserEntity userEntity);
  Future<void> signOut();
  Future<Pay> addPay(Pay pay);
  Future<void> addContact(Contact contact, String paidId);
  Future<UserEntity?> getCurrentUser(UserEntity userEntity);
  Future<Pay?> getPayById(String id);
  Future<Contact?> getContactById(String cId, String paidId);
  Future<bool> isSignIn();
  Future<String> getCurrentUUid();
  Future<UserEntity?> getUserByUuid();
  Stream<List<Pay>> getPays();
  Stream<List<Contact>> getContacts(String paidId);
}