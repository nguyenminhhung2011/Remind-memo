import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/core/dependency_injection/di.dart';
import 'package:project/core/extensions/color_extensions.dart';
import 'package:project/feature/auth/notifier/auth_notifier.dart';
import 'package:project/feature/list_contact/notifier/contact_notifier.dart';
import 'package:project/feature/paid/notifier/paid_notifier.dart';
import 'package:project/routes/main_routes.dart';
import 'package:project/routes/routes.dart';

import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'data/data_source/preferences.dart';
import 'generated/l10n.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Preferences.ensureInitedPreferences();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthNotifier>(create: (_) => injector.get()),
          ChangeNotifierProvider<PaidNotifier>(create: (_) => injector.get()),
          ChangeNotifierProvider<ContactNotifier>(create: (_) => injector.get())
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: 'Remind Memo',
          theme: ThemeData(
            primaryColor: '#07AEAF'.toColor(),
            primaryColorDark: '#07AEAF'.toColor(),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: '#07AEAF'.toColor(),
          ),
          supportedLocales: S.delegate.supportedLocales,
          initialRoute: Routes.splash,
          onGenerateRoute: MainRoutes.getRoute,
        ));
  }
} 


  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: 'AIzaSyAd2vg-g4QuV_vv9wIAt8tZQ5_5fdEIFQE',
  //       appId: '1:397479097226:web:dd8e264d37407d9a104e73',
  //       messagingSenderId: '397479097226',
  //       projectId: 'instagram-tut-c1e36',
  //       storageBucket: 'instagram-tut-c1e36.appspot.com',
  //     ),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }


  //       stream: FirebaseAuth.instance.authStateChanges(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.active) {
    //           // Checking if the snapshot has any data or not
    //           if (snapshot.hasData) {
    //             // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
    //             return const ResponsiveLayout(
    //               mobileScreenLayout: MobileScreenLayout(),
    //               webScreenLayout: WebScreenLayout(),
    //             );
    //           } else if (snapshot.hasError) {
    //             return Center(
    //               child: Text('${snapshot.error}'),
    //             );
    //           }
    //         }

    //         // means connection to future hasnt been made yet
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return const Center(
    //             child: CircularProgressIndicator(),
    //           );
    //         }

    //         return const LoginScreen();
    //       },
    //     ), // La 1 luong du lieu khi nguoi dung thay doi man hinh ui co data
    //   ),