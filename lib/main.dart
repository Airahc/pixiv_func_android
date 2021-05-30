/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : main.dart
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pixiv_xiaocao_android/android_tabs.dart';
import 'package:pixiv_xiaocao_android/platform_util.dart';
import 'package:pixiv_xiaocao_android/util.dart';
import 'package:provider/provider.dart';

Future main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;

  runApp(AndroidApp());
}

late DateTime _lastPopTime;

class AndroidApp extends StatelessWidget {
  AndroidApp() {
    _lastPopTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
        ],
        theme: ThemeData(
          accentColor: Colors.pinkAccent,
          toggleableActiveColor: const Color(0xffea638c),
          colorScheme: ColorScheme(
            primary: const Color(0xffea638c),
            primaryVariant: Colors.deepOrangeAccent,
            secondary: const Color(0xffea638c),
            secondaryVariant: const Color(0xffea638c),
            surface: const Color(0xff30343f),
            background: const Color(0xff30343f),
            error: Colors.red,
            onPrimary: const Color(0xff1b2021),
            onSecondary: const Color(0xff1b2021),
            onSurface: const Color(0xffffd9da),
            onBackground: const Color(0xffffd9da),
            onError: const Color(0xff1b2021),
            brightness: Brightness.dark,
          ),
        ),
        home: WillPopScope(
          child: AndroidTabs(),
          onWillPop: () async {
            if (DateTime.now().difference(_lastPopTime) >
                Duration(seconds: 2)) {
              _lastPopTime = DateTime.now();
              Util.toast('再按一次退出',
                  backgroundColor: Colors.black54,
                  textStyle: TextStyle(
                    fontSize: 22,
                    color: Colors.pinkAccent,
                  ),
                  duration: Duration(seconds: 1));
              return false;
            } else {
              _lastPopTime = DateTime.now();
              await PlatformUtil.backgroundRun();
              return false;
            }
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}
