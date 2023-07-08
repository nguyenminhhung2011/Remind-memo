import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';
import 'package:project/domain/enitites/contact/contact.dart';
import 'package:project/domain/enitites/pay/pay.dart';
import 'package:project/domain/enitites/user_entity.dart';

import '../data_source/firebase_datasource.dart';

@Injectable(as: FirebaseRepository)
class FirebaseRepositoryImpl implements FirebaseRepository {
  final FirebaseDataSource firebaseDataSource;
  FirebaseRepositoryImpl(this.firebaseDataSource);

  @override
  Future<void> googleAuth() => firebaseDataSource.googleAuth();

  @override
  Future<void> signUp(UserEntity userEntity) =>
      firebaseDataSource.signUp(userEntity);

  @override
  Future<UserEntity?> getCurrentUser(UserEntity userEntity) =>
      firebaseDataSource.getCreateCurrentUser(userEntity);

  @override
  Future<bool> isSignIn() => firebaseDataSource.isSignIn();

  @override
  Future<void> signIn(UserEntity userEntity) =>
      firebaseDataSource.signIn(userEntity);

  @override
  Future<String> getCurrentUUid() => firebaseDataSource.getCurrentUId();

  @override
  Future<UserEntity?> getUserByUuid() => firebaseDataSource.getUserByUuid();

  @override
  Stream<List<Pay>> getPays() => firebaseDataSource.getPays();

  @override
  Future<Pay> addPay(Pay pay) => firebaseDataSource.addPays(pay);

  @override
  Future<void> signOut() => firebaseDataSource.signOut();

  @override
  Future<Pay?> getPayById(String id) => firebaseDataSource.getPayById(id);

  @override
  Stream<List<Contact>> getContacts(String paidId) =>
      firebaseDataSource.getContacts(paidId);

  @override
  Future<void> addContact(Contact contact, String paidId) => firebaseDataSource.addContacts(contact, paidId);
  
  @override
  Future<Contact?> getContactById(String cId, String paidId) => firebaseDataSource.getContactById(cId, paidId);
}
