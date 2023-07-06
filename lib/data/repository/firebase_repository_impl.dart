import 'package:injectable/injectable.dart';
import 'package:project/data/repository/firebase_repository.dart';

import '../data_source/firebase_datasource.dart';

@Injectable(as: FirebaseRepository)
class FirebaseRepositoryImpl implements FirebaseRepository{
  final FirebaseDataSource firebaseDataSource;
  FirebaseRepositoryImpl(this.firebaseDataSource);

  @override
  Future<void> googleAuth() => firebaseDataSource.googleAuth();

}