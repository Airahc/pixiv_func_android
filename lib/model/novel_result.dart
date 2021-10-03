/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:novel_result.dart
 * 创建时间:2021/10/3 上午8:56
 * 作者:小草
 */
import 'package:pixiv_func_android/api/model/novel_js_data.dart';

class NovelResult {
  NovelJSData novel;
  String text;

  NovelResult(this.novel, this.text);
}

