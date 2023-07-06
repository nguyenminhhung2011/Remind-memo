import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';
// import 'di.config.dart';

GetIt injector = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
  externalPackageModulesBefore: [],
)
GetIt configureDependencies({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  injector.registerSingleton<FirebaseFirestore>(firebaseFirestore);
  injector.registerSingleton<GoogleSignIn>(googleSignIn);
  injector.registerSingleton<FirebaseAuth>(auth);
  return init(
    injector,
    environment: environment,
    environmentFilter: environmentFilter,
  );
}
