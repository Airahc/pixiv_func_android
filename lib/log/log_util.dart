/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : log_util.dart
 */

import 'package:flutter/cupertino.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/pages/log/log_page.dart';

class LogUtil {
  static final _instance = LogUtil();

  static LogUtil get instance {
    return _instance;
  }

  GlobalKey<LogPageState> globalKey = GlobalKey();

  void add({
    required LogType type,
    required int id,
    required String title,
    required String url,
    required String context,
    Exception? exception,
  }) {
    globalKey.currentState?.addLog(
      type: type,
      id: id,
      title: title,
      url: url,
      context: context,
      exception: exception,
    );
  }

  void clear() {
    globalKey.currentState?.clearLog();
  }
}
