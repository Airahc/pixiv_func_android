/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:theme_model.dart
 * 创建时间:2021/8/23 上午9:56
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';

class ThemeModel extends BaseViewModel {
  static final _darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme(
      primary: Color(0xffea638c),
      primaryVariant: Colors.pinkAccent,
      secondary: Colors.pinkAccent,
      secondaryVariant: Color(0xffea638c),
      surface: Color(0xff303235),
      background: Color(0xff282c2f),
      error: Colors.red,
      onPrimary: Color(0xffffd9da),
      onSecondary: Color(0xffffd9da),
      onSurface: Colors.white70,
      onBackground: Color(0xff191a1a),
      onError: Colors.deepOrange,
      brightness: Brightness.dark,
    )
  );

  static final _lightTheme = ThemeData.light().copyWith(
    colorScheme: const ColorScheme(
      primary: Color(0xffea638c),
      primaryVariant: Colors.deepOrangeAccent,
      secondary: Colors.pinkAccent,
      secondaryVariant: Color(0xffea638c),
      surface: Color(0xff40444d),
      background: Color(0xff40444d),
      error: Colors.red,
      onPrimary: Color(0xffffd9da),
      onSecondary: Color(0xffffd9da),
      onSurface: Color(0xff191a1a),
      onBackground: Color(0xff191a1a),
      onError: Colors.red,
      brightness: Brightness.light,
    ),
  );

  var _currentTheme = _darkTheme;

  ThemeModel(bool isLightTheme) {
    if (isLightTheme) {
      _currentTheme = _lightTheme;
    }
  }

  ThemeData get currentTheme => _currentTheme;

  set useLightTheme(bool value) {
    if (value) {
      if (_lightTheme == _currentTheme) {
        return;
      }
      _currentTheme = _lightTheme;
    } else {
      if (_darkTheme == _currentTheme) {
        return;
      }
      _currentTheme = _darkTheme;
    }
    notifyListeners();
  }
}
