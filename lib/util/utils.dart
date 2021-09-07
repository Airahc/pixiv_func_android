/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:utils.dart
 * 创建时间:2021/8/26 下午1:30
 * 作者:小草
 */

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Utils {
  /// 枚举类型(的值)转小写字符串
  /// WorkType.ILLUST => 'illust'
  static String enumTypeStringToLowerCase<T extends Enum>(T type) {
    final typeString = type.toString();
    final typeRuntimeTypeString = type.runtimeType.toString();
    return typeString.replaceFirst('$typeRuntimeTypeString.', '').toLowerCase();
  }

  ///日本时间转中国时间
  static String japanDateToLocalDateString(DateTime dateTime) {
    return DateFormat('yyyy年MM月dd日 HH:mm:ss').format(dateTime.toLocal());
  }

  static Future<void> copyToClipboard(String data) async {
    await Clipboard.setData(ClipboardData(text: data));
  }

}
