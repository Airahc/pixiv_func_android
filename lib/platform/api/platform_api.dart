/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:platform.dart
 * 创建时间:2021/8/20 下午1:35
 * 作者:小草
 */

import 'dart:typed_data';

import 'package:flutter/services.dart';

class PlatformAPI {
  static const _pluginName = 'xiaocao/platform/api';
  final _methodImageIsExist = 'imageIsExist';
  final _methodSaveImage = 'saveImage';
  final _methodToast = 'toast';
  final _methodGetBuildVersion = 'getBuildVersion';
  final _methodGetAppVersion = 'getAppVersion';
  final _methodUrlLaunch = 'urlLaunch';

  final _channel = MethodChannel(_pluginName);

  Future<bool> imageIsExist(String filename) async {
    final result = await _channel.invokeMethod(_methodImageIsExist, {
      'filename': filename,
    });
    return true == result;
  }

  Future<bool?> saveImage(Uint8List imageBytes, String filename) async {
    try {
      final result = await _channel.invokeMethod(_methodSaveImage, {
        'imageBytes': imageBytes,
        'filename': filename,
      });
      return result;
    } on PlatformException {
      toast('保存失败 可能是没有存储权限');
      return null;
    }
  }

  Future<void> toast(String content, {bool isLong = false}) async {
    await _channel.invokeMethod(_methodToast, {
      'content': content,
      'isLong': isLong,
    });
  }

  Future<int> get buildVersion async {
    final result = await _channel.invokeMethod(_methodGetBuildVersion);
    return result as int;
  }

  Future<String> get appVersion async {
    final result = await _channel.invokeMethod(_methodGetAppVersion);
    return result as String;
  }


  Future<bool> urlLaunch(String url) async {
    final result = await _channel.invokeMethod(_methodUrlLaunch, {
      'url': url,
    });
    return result as bool;
  }

}
