/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:settings_manager.dart
 * 创建时间:2021/9/6 下午5:56
 * 作者:小草
 */

import 'package:pixiv_func_android/instance_setup.dart';
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

    final previewQuality = sharedPreferences.getBool('preview_quality');
    if (null != previewQuality) {
      settings.previewQuality = previewQuality;
    }

    final scaleQuality = sharedPreferences.getBool('scale_quality');
    if (null != scaleQuality) {
      settings.scaleQuality = scaleQuality;
    }

    final enableBrowsingHistory = sharedPreferences.getBool('enable_browsing_history');
    if (null != enableBrowsingHistory) {
      settings.enableBrowsingHistory = enableBrowsingHistory;
    }
  }

  bool get isLightTheme => settings.isLightTheme;

  set isLightTheme(bool value) {
    settings.isLightTheme = value;
    sharedPreferences.setBool('is_light_theme', value);
    themeModel.useLightTheme = value;
  }

  String get imageSource => settings.imageSource;

  set imageSource(String value) {
    settings.imageSource = value;
    sharedPreferences.setString('image_source', value);
  }

  bool get previewQuality => settings.previewQuality;

  set previewQuality(bool value) {
    settings.previewQuality = value;
    sharedPreferences.setBool('preview_quality', value);
  }

  bool get scaleQuality => settings.scaleQuality;

  set scaleQuality(bool value) {
    settings.scaleQuality = value;
    sharedPreferences.setBool('scale_quality', value);
  }

  bool get enableBrowsingHistory => settings.enableBrowsingHistory;

  set enableBrowsingHistory(bool value) {
    settings.enableBrowsingHistory = value;
    sharedPreferences.setBool('enable_browsing_history', value);
  }
}
