/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_android
 * 文件名称:settings_manager.dart
 * 创建时间:2021/9/6 下午5:56
 * 作者:小草
 */

import 'package:pixiv_func_android/model/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  final Settings settings = Settings();

  late final SharedPreferences sharedPreferences;

  Future<void> load() async {
    sharedPreferences = await SharedPreferences.getInstance();

    final isLightTheme = sharedPreferences.getBool('is_light_theme');
    if (null != isLightTheme) {
      settings.isLightTheme = isLightTheme;
    }

    final imageSource = sharedPreferences.getString('image_source');
    if (null != imageSource) {
      settings.imageSource = imageSource;
    }
  }

  bool get isLightTheme => settings.isLightTheme;

  set isLightTheme(bool value) {
    settings.isLightTheme = value;
    sharedPreferences.setBool('is_light_theme', value);
  }

  String get imageSource => settings.imageSource;

  set imageSource(String value) {
    settings.imageSource = value;
    sharedPreferences.setString('image_source', value);
  }
}
