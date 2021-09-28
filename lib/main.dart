/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:main.dart
 * 创建时间:2021/8/20 下午12:18
 * 作者:小草
 */

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pixiv_func_android/app.dart';
import 'package:pixiv_func_android/instance_setup.dart';


Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  //一定要初始化
  WidgetsFlutterBinding.ensureInitialized();


  await init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeModel),
        ChangeNotifierProvider(create: (context) => accountModel),
        ChangeNotifierProvider(create: (context) => homeModel),
        ChangeNotifierProvider(create: (context) => downloadTaskModel),
      ],
      child: const App(),
    ),
  );

  final storageStatus = Permission.storage;

  if (!await storageStatus.isGranted) {
    Permission.storage.request();
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
