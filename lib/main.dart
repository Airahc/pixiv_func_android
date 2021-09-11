/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:main.dart
 * 创建时间:2021/8/20 下午12:18
 * 作者:小草
 */

import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixiv_func_android/app.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/view_model/theme_model.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //一定要初始化
  WidgetsFlutterBinding.ensureInitialized();
  (ExtendedNetworkImageProvider.httpClient as HttpClient).badCertificateCallback =
      (X509Certificate cert, String host, int port) {
    return true;
  };

  await init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeModel(settingsManager.isLightTheme)),
        ChangeNotifierProvider(create: (context) => accountModel),
        ChangeNotifierProvider(create: (context) => homeModel),
        ChangeNotifierProvider(create: (context) => downloadTaskModel),
      ],
      child: App(),
    ),
  );

  //Build.VERSION_CODES.Q
  if (await platformAPI.buildVersion < 29) {
    final storageStatus = Permission.storage;

    if (!await storageStatus.isGranted) {
      Permission.storage.request();
    }
  }
}

