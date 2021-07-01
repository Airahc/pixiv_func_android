/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : platform_util.dart
 */

import 'dart:typed_data';

import 'package:flutter/services.dart';

class PlatformUtil {
  static const String _ChannelName = "android/platform/api";

  static const String _eventBackToDesktop = "backDesktop";
  static const String _eventBackgroundRun = "backgroundRun";
  static const String _eventSaveImage = "saveImage";
  static const String _eventImageIsExist = "imageIsExist";
  static const String _eventGetDataPath = "eventGetDataPath";

  static final _channel = MethodChannel(_ChannelName);

  static Future<void> backToDesktop() async {
    await _channel.invokeMethod(_eventBackToDesktop);
  }

  static Future<void> backgroundRun() async {
    await _channel.invokeMethod(_eventBackgroundRun);
  }

  static Future<bool?> saveImage(Uint8List imageBytes, String fileName) async {
    final result = await _channel.invokeMethod<bool?>(
      _eventSaveImage,
      {
        "imageBytes": imageBytes,
        "fileName": fileName,
      },
    );
    return result;
  }

  static Future<bool> imageIsExist(String fileName) async {
    final success = await _channel.invokeMethod<bool>(
      _eventImageIsExist,
      {
        "fileName": fileName,
      },
    );

    return success == true;
  }

  static Future<String?> getDataPath() async {
    String? result = '';
    result = await _channel.invokeMethod<String>(_eventGetDataPath);

    return result == '' ? null : result;
  }
}
