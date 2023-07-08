import 'package:project/domain/enitites/contact/contact.dart';

import '../../domain/enitites/pay/pay.dart';
import '../../domain/enitites/user_entity.dart';

abstract class FirebaseDataSource {
  Future<UserEntity?> getCreateCurrentUser(UserEntity user);
  Future<UserEntity?> getUserByUuid();
  Future<Pay?> getPayById(String id);
  Future<Contact?> getContactById(String cId, String paidId);
  Future<void> googleAuth();
  Future<void> forgotPassword(String email);

  // Future<void> getCreateGroup(GroupEntity groupEntity);
  // Stream<List<GroupEntity>> getGroups();
  // Future<void> joinGroup(GroupEntity groupEntity);
  // Future<void> updateGroup(GroupEntity groupEntity);

  Future<bool> isSignIn();
  Future<void> signIn(UserEntity user);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<Pay> addPays(Pay pay);
  Future<void> addContacts(Contact pay, String paidId );
  Future<void> getUpdateUser(UserEntity user);
  Future<String> getCurrentUId();
  Future<void> signUpWithPhoneNumber(String phoneNumber);
  Stream<List<Pay>> getPays();
  Stream<List<Contact>> getContacts(String paidId);


}
