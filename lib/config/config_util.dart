/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : config_util.dart
 */

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/config/config_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/platform_util.dart';
import 'package:pixiv_xiaocao_android/utils.dart';

class ConfigUtil {
  static const referer = 'https://www.pixiv.net/';
  static const userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101 Firefox/88.0';

  static final _instance = ConfigUtil();

  static ConfigUtil get instance {
    return _instance;
  }

  ConfigEntity config = ConfigEntity.fromJson({});

  Future loadConfigFile() async {
    final dataPath = await PlatformUtil.getDataPath();
    var json = <String, dynamic>{};
    if (dataPath != null) {
      final configFile = File('$dataPath/Config.json');
      if (configFile.existsSync()) {
        json = jsonDecode(configFile.readAsStringSync());
        config = ConfigEntity.fromJson(json);
        PixivRequest.instance.updateHeaders();
      }
    }
  }

  Future updateConfigFile() async {
    final dataPath = await PlatformUtil.getDataPath();
    if (dataPath != null) {
      final configFile = File('$dataPath/Config.json');
      configFile.writeAsStringSync(jsonEncode(config.toJson()));
    }
  }

  Future<void> updateJsonStringToConfig(String jsonString) async {
    try {
      config = ConfigEntity.fromJson(jsonDecode(jsonString));
      await updateConfigFile();
      Utils.toast('导入成功');
    } on Exception catch (e) {
      Utils.toast('导入失败');
      LogUtil.instance.add(
        type: LogType.Info,
        id: -1,
        title: '从剪切板导入配置信息失败',
        url: '',
        context: '反序列化异常',
        exception: e,
      );
    }
  }


}
