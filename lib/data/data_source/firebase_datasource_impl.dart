import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:project/data/model/contact/contact_model.dart';
import 'package:project/data/model/pay/pay_model.dart';
import 'package:project/domain/enitites/contact/contact.dart';
import 'package:project/domain/enitites/pay/pay.dart';
import 'package:project/domain/enitites/user_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../model/user_model.dart';
import 'firebase_datasource.dart';

@Injectable(as: FirebaseDataSource)
class FirebaseDataSourceImpl implements FirebaseDataSource {
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore fireStore;
  final FirebaseAuth auth;

  FirebaseDataSourceImpl(this.fireStore, this.auth,
      {required this.googleSignIn});

  @override
  Future<void> forgotPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> updateUserImage(String url, String uid) async {
    final userCollection = fireStore.collection('users');
    userCollection.doc(uid).update({
      'profileUrl': url,
    });
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = fireStore.collection('users');
    return userCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }

  @override
  Future<void> changePasswod(String newPassword, String uid) async {
    final user = auth.currentUser;
    await user?.updatePassword(newPassword).then((_) {
      log("Update password is successfully");
    }).catchError((error) {
      log(error.toString());
    });
  }

  @override
  Future<UserEntity?> getCreateCurrentUser(UserEntity user) async {
    final userCollection = fireStore.collection('users');
    final uid = await getCurrentUId();
    final newUser = UserModel(
      name: user.name.isEmpty ? user.email.split('@')[0].toString() : user.name,
      uid: uid,
      phoneNumber: user.phoneNumber,
      email: user.email,
      profileUrl: user.profileUrl,
      isOnline: user.isOnline,
      status: user.status,
      dob: user.dob,
      gender: user.gender,
    ).toDocument();

    try {
      final userDoc = await userCollection.doc(uid).get();
      if (!userDoc.exists) {
        await userCollection.doc(uid).set(newUser);
        return UserModel.fromJson(newUser).toEntity();
      } else {
        await userCollection.doc(uid).update(newUser);
        log("user already exist");
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  Future<UserEntity?> getUserByUuid() async {
    String uid = auth.currentUser?.uid ?? "";
    if (uid.isEmpty) {
      return null;
    }
    final userCollection = fireStore.collection('users');
    try {
      final userDoc = await userCollection.doc(uid).get();
      if (!userDoc.exists) {
        return null;
      }
      return UserModel.fromSnapshot(userDoc).toEntity();
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  Future<Pay?> getPayById(String id) async {
    final payCollection = fireStore.collection('pays');
    try {
      final payDoc = await payCollection.doc(id).get();
      if (!payDoc.exists) {
        return null;
      }
      return PayModel.fromJson(payDoc.data()!).toEntity;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  Future<String> getCurrentUId() async => auth.currentUser!.uid;

  @override
  Future<void> getUpdateUser(UserEntity user) async {
    log('Update user function is called');
    Map<String, dynamic> userInformation = Map();
    final userCollection = fireStore.collection("users");

    // if (user.profileUrl != null && user.profileUrl != "") {
    //   userInformation['profileUrl'] = user.profileUrl;
    // }
    if (user.status != "") {
      userInformation['status'] = user.status;
    }
    if (user.phoneNumber != "") {
      userInformation["phoneNumber"] = user.phoneNumber;
    }
    if (user.name != "") {
      userInformation["name"] = user.name;
    }

    userCollection.doc(user.uid).update(userInformation);
  }

  @override
  Future<void> googleAuth() async {
    final collection = fireStore.collection('users');
    try {
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await account!.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final information =
          (await auth.signInWithCredential(authCredential)).user;
      collection.doc(auth.currentUser!.uid).get().then((value) async {
        if (!value.exists) {
          var uid = auth.currentUser!.uid;
          var newUser = UserModel(
                  name: information!.displayName!,
                  email: information.email!,
                  phoneNumber: information.phoneNumber == null
                      ? ""
                      : information.phoneNumber!,
                  profileUrl:
                      information.photoURL == null ? "" : information.photoURL!,
                  isOnline: false,
                  status: "",
                  dob: "",
                  gender: "",
                  uid: information.uid)
              .toDocument();
          collection.doc(uid).set(newUser);
        }
      }).whenComplete(() => log("New User Created Successfully"));
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  // ignore: unnecessary_null_comparison
  Future<bool> isSignIn() async => auth.currentUser!.uid != null;

  @override
  Future<void> signIn(UserEntity user) async {
    await auth.signInWithEmailAndPassword(
      email: user.email,
      password: user.password,
    );
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> signUp(UserEntity user) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> signUpWithPhoneNumber(String phoneNumber) async {
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verficationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Stream<List<Pay>> getPays() {
    final payCollection = fireStore.collection("pays");
    return payCollection.snapshots().map((querySnapshot) => querySnapshot.docs
        .map((e) => PayModel.fromJson(e.data()).toEntity)
        .toList());
  }

  @override
  Future<Pay> addPays(Pay pay) async {
    final payCollection = fireStore.collection("pays");
    final payId = payCollection.doc().id;
    await payCollection.doc(payId).set(PayModel(
          payId,
          pay.name,
          pay.uuid,
          0,
          0,
        ).toJson());
    return Pay(
      id: payId,
      uuid: pay.uuid,
      name: pay.name,
      lendAmount: 0,
      loanAmount: 0,
    );
  }

  @override
  Stream<List<Contact>> getContacts(String paidId) {
    final contactCollection =
        fireStore.collection("pays").doc(paidId).collection("contacts");
    return contactCollection.snapshots().map((querySnapshot) => querySnapshot
        .docs
        .map((e) => ContactModel.fromJson(e.data()).toEntity)
        .toList());
  }

  @override
  Future<void> addContacts(Contact contact, String paidId) async {
    final contactCollection =
        fireStore.collection("pays").doc(paidId).collection("contacts");
    final contactId = contactCollection.doc().id;
    await contactCollection.doc(contactId).set(
          ContactModel(contactId, contact.name, contact.phoneNumber,
                  contact.note, contact.type, 0, 0)
              .toJson(),
        );
  }

  @override
  Future<Contact?> getContactById(String cId, String paidId) async {
    final contactCollection =
        fireStore.collection('pays').doc(paidId).collection('contacts');
    try {
      final contactDoc = await contactCollection.doc(cId).get();
      if (!contactDoc.exists) {
        return null;
      }
      return ContactModel.fromJson(contactDoc.data()!).toEntity;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
