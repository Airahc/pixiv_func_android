/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:settings_model.dart
 * 创建时间:2021/9/6 下午6:13
 * 作者:小草
 */

import 'package:flutter/cupertino.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class SettingsModel extends BaseViewModel {
  final customImageSourceInput = TextEditingController();

  @override
  void dispose(){
    customImageSourceInput.dispose();
    super.dispose();
  }

  bool get isLightTheme => settingsManager.isLightTheme;

  set isLightTheme(bool value) {
    settingsManager.isLightTheme = value;
    notifyListeners();
  }

  String get imageSource => settingsManager.imageSource;

  set imageSource(String value) {
    settingsManager.imageSource = value;
    notifyListeners();
  }


  bool get previewQuality => settingsManager.previewQuality;

  set previewQuality(bool value) {
    settingsManager.previewQuality = value;
    notifyListeners();
  }

  bool get scaleQuality => settingsManager.scaleQuality;

  set scaleQuality(bool value) {
    settingsManager.scaleQuality = value;
    notifyListeners();
  }

  bool get enableBrowsingHistory => settingsManager.enableBrowsingHistory;

  set enableBrowsingHistory(bool value) {
    settingsManager.enableBrowsingHistory = value;
    notifyListeners();
  }

}
