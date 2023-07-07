// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i5;
import 'package:firebase_auth/firebase_auth.dart' as _i6;
import 'package:get_it/get_it.dart' as _i1;
import 'package:google_sign_in/google_sign_in.dart' as _i7;
import 'package:injectable/injectable.dart' as _i2;

import '../../data/data_source/firebase_datasource.dart' as _i3;
import '../../data/data_source/firebase_datasource_impl.dart' as _i4;
import '../../data/repository/firebase_repository.dart' as _i8;
import '../../data/repository/firebase_repository_impl.dart' as _i9;
import '../../feature/auth/notifier/auth_notifier.dart' as _i13;
import '../../feature/auth/notifier/login_notifier.dart' as _i10;
import '../../feature/auth/notifier/register_notifier.dart' as _i12;
import '../../feature/paid/notifier/paid_notifier.dart' as _i11;

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
_i1.GetIt init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.FirebaseDataSource>(() => _i4.FirebaseDataSourceImpl(
        gh<_i5.FirebaseFirestore>(),
        gh<_i6.FirebaseAuth>(),
        googleSignIn: gh<_i7.GoogleSignIn>(),
      ));
  gh.factory<_i8.FirebaseRepository>(
      () => _i9.FirebaseRepositoryImpl(gh<_i3.FirebaseDataSource>()));
  gh.factory<_i10.LoginNotifier>(
      () => _i10.LoginNotifier(gh<_i8.FirebaseRepository>()));
  gh.factory<_i11.PaidNotifier>(
      () => _i11.PaidNotifier(gh<_i8.FirebaseRepository>()));
  gh.factory<_i12.RegisterNotifier>(
      () => _i12.RegisterNotifier(gh<_i8.FirebaseRepository>()));
  gh.factory<_i13.AuthNotifier>(
      () => _i13.AuthNotifier(gh<_i8.FirebaseRepository>()));
  return getIt;
}
