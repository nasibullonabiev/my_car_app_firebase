import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:my_car_app_firebase/pages/add_car_page.dart';
import 'package:my_car_app_firebase/pages/home_page.dart';
import 'package:my_car_app_firebase/pages/sign_in_page.dart';
import 'package:my_car_app_firebase/services/auth_service.dart';
import 'package:my_car_app_firebase/services/db_service.dart';

import 'firebase_options.dart';

void main()async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await runZonedGuarded(() async {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyCarApp());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyCarApp extends StatelessWidget {

  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  const MyCarApp({Key? key}) : super(key: key);

  Widget _startPage() {
    return StreamBuilder<User?>(
      stream: AuthService.auth.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          DBService.saveUserId(snapshot.data!.uid);
          return const HomePage();
        } else {
          DBService.removeUserId();
          return const SignInPage();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      home: const HomePage(),
      routes: {
        HomePage.id : (context) => const HomePage(),
        AddCarPage.id : (context) => const AddCarPage(),

      },
    );
  }
}
