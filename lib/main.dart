import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hankammeleducation/screens/launchscreen.dart';
import 'package:hankammeleducation/search/search.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hankammeleducation/screens/connectionstate.dart';
import 'pref/shared_pref_controller.dart';
import 'screens/quiz/quiz_screen.dart';
import 'screens/webview_screen.dart';
bool isConnected = false;

void main() async {
  await checkInternetConnection();
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPreferences();
  await Firebase.initializeApp();
  await Hive.initFlutter(); // تهيئة Hive
  await Hive.openBox('downloads'); // فتح صندوق التحميلات
  //WebViewPlatform.instance = WebWebViewPlatform();

  runApp(MyApp());
}

Future<void> checkInternetConnection() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) ;
    isConnected = true;
  } on SocketException catch (_) {
    isConnected = false;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2340),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              //AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            supportedLocales: const [Locale('ar'), Locale('en')],
            locale: const Locale('ar'),
            title: '',
            theme: ThemeData(
              useMaterial3: true,
              primarySwatch: Colors.blue,
            ),
            home:
                isConnected ? LaunchScreen() : const ConnectionStateScreen());
      },
    );
  }
}
