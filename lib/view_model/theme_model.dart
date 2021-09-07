/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:theme_model.dart
 * 创建时间:2021/8/23 上午9:56
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class ThemeModel extends BaseViewModel {
  static final _darkTheme = ThemeData(
    colorScheme: ColorScheme(
      primary: const Color(0xffea638c),
      primaryVariant: Colors.pinkAccent,
      secondary: Colors.pinkAccent,
      secondaryVariant: const Color(0xffea638c),
      surface: const Color(0xff303235),
      background: const Color(0xff282c2f),
      error: Colors.red,
      onPrimary: const Color(0xffffd9da),
      onSecondary: const Color(0xffffd9da),
      onSurface: Colors.white70,
      onBackground: const Color(0xff191a1a),
      onError: Colors.deepOrange,
      brightness: Brightness.dark,
    ),
    brightness: Brightness.dark,
  );

  static final _lightTheme = ThemeData(
    colorScheme: ColorScheme(
      primary: const Color(0xffea638c),
      primaryVariant: Colors.deepOrangeAccent,
      secondary: Colors.pinkAccent,
      secondaryVariant: const Color(0xffea638c),
      surface: const Color(0xff40444d),
      background: const Color(0xff40444d),
      error: Colors.red,
      onPrimary: const Color(0xffffd9da),
      onSecondary: const Color(0xffffd9da),
      onSurface: const Color(0xff191a1a),
      onBackground: const Color(0xff191a1a),
      onError: Colors.red,
      brightness: Brightness.light,
    ),
    brightness: Brightness.light,
  );

  var _currentTheme = _darkTheme;

  ThemeModel(bool isLightTheme) {
    if (isLightTheme) {
      _currentTheme = _lightTheme;
    }
  }

  ThemeData get currentTheme => _currentTheme;

  void useDarkTheme() async {
    if (_darkTheme == _currentTheme) {
      return;
    }
    settingsManager.isLightTheme = false;
    _currentTheme = _darkTheme;
    notifyListeners();
  }

  void useLightTheme() async {
    if (_lightTheme == _currentTheme) {
      return;
    }
    settingsManager.isLightTheme = true;
    _currentTheme = _lightTheme;
    notifyListeners();
  }
}
