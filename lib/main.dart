import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shamssgazaa/screens/auth_screens/login_screen.dart';
import 'package:shamssgazaa/screens/auth_screens/verifyPhone_screen.dart';
import 'package:shamssgazaa/screens/connectionstate.dart';
import 'package:shamssgazaa/course/courseDetails.dart';
import 'package:shamssgazaa/screens/profile_screen.dart';
import 'package:shamssgazaa/utils/helpers.dart';
import 'pref/shared_pref_controller.dart';
import 'screens/auth_screens/register_screen.dart';
import 'screens/bottomNavigationBar.dart';
import 'screens/home_screen.dart';
import 'screens/launchscreen.dart';
import 'screens/my_course_screen.dart';


bool isConnected = false;

void main() async {
  await checkInternetConnection();
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPreferences();
  await Firebase.initializeApp();
  await Hive.initFlutter(); // تهيئة Hive
  await Hive.openBox('downloads'); // فتح صندوق التحميلات

  runApp(MyApp());
}


Future<void> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty);
    isConnected = true;
  } on SocketException catch (_) {
    isConnected = false;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          //AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        supportedLocales: const [Locale('ar'), Locale('en')],
        locale: Locale('ar'),
        title: '',
        theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
        ),
        home: isConnected ? LaunchScreen() : ConnectionStateScreen());
  }
}
