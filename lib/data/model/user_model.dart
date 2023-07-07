import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/enitites/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    String name = "username",
    String email = "",
    String phoneNumber = "",
    bool isOnline = false,
    String uid = "",
    String status = "",
    String profileUrl = "",
    String dob = "",
    String gender = "",
    String password = "",
  }) : super(
          name: name,
          email: email,
          phoneNumber: phoneNumber,
          isOnline: isOnline,
          uid: uid,
          status: status,
          profileUrl: profileUrl,
          gender: gender,
          dob: dob,
          password: password,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      isOnline: json['isOnline'],
      uid: json['uid'],
      status: json['status'],
      profileUrl: json['profileUrl'],
    );
  }

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      name: snapshot.get('name') ?? "",
      email: snapshot.get('email')?? "",
      phoneNumber: snapshot.get('phoneNumber')?? "",
      isOnline: snapshot.get('isOnline')?? true,
      uid: snapshot.get('uid')?? "",
      status: snapshot.get('status')?? "",
      profileUrl: snapshot.get('profileUrl')?? "",
      dob: snapshot.get('dob')?? "",
      gender: snapshot.get('gender')?? "",
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      name: name,
      email: email,
      dob: dob,
      phoneNumber: phoneNumber,
      uid: uid,
      status: status,
      gender: gender,
      isOnline: isOnline,
      profileUrl: profileUrl,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "isOnline": isOnline,
      "uid": uid,
      "status": status,
      "profileUrl": profileUrl,
      "dob": dob,
      "gender": gender,
    };
  }
}
