/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:page_utils.dart
 * 创建时间:2021/8/23 下午9:46
 * 作者:小草
 */

import 'package:flutter/material.dart';

class PageUtils {
  static void to(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  static void back(BuildContext context) {
    Navigator.pop(context);
  }
}
