/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:utils.dart
 * 创建时间:2021/8/26 下午1:30
 * 作者:小草
 */

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pixiv_func_android/api/entity/image_urls.dart';
import 'package:pixiv_func_android/instance_setup.dart';

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

  static String replaceImageSource(String url) {
    return url.replaceFirst('i.pximg.net', settingsManager.imageSource);
  }

  static String getPreviewUrl(ImageUrls imageUrls) {
    return settingsManager.previewQuality ? imageUrls.large : imageUrls.medium;
  }

  ///字符串是否是 twitter/用户名
  static bool textIsTwitterUser(String text) {
    return RegExp(r'([Tt]witter/)(\w{1,15})\b').hasMatch(text);
  }

  ///查找文本里的推特用户名
  static String findTwitterUsernameByText(String url) {
    return RegExp(r'(?<=([Tt]witter/))(\w{1,15})\b$').stringMatch(url)!;
  }

  ///推特账号(https://twitter.com https://mobile.twitter.com)
  static bool urlIsTwitter(String url) {
    return RegExp(r'(https://).*(twitter.com/)(\w{1,15})\b$').hasMatch(url);
  }

  ///查找url里的推特用户名
  static String findTwitterUsernameByUrl(String url) {
    return RegExp(r'(?<=(https://).*(twitter.com/))(\w{1,15})\b$').stringMatch(url)!;
  }

  ///插画页面
  static bool urlIsIllust(String url) {
    return RegExp(r'pixiv://illusts/([1-9][0-9]*)\b').hasMatch(url);
  }

  ///查找url里的插画ID
  static int findIllustIdByUrl(String url) {
    return int.parse(RegExp(r'(?<=pixiv://illusts/)([1-9][0-9]*)\b').stringMatch(url)!);
  }

  ///用户页面
  static bool urlIsUser(String url) {
    return RegExp(r'pixiv://users/([1-9][0-9]*)\b').hasMatch(url);
  }

  ///查找url里的用户ID
  static int findUserIdByUrl(String url) {
    return int.parse(RegExp(r'(?<=pixiv://users/)([1-9][0-9]*)\b').stringMatch(url)!);
  }
}
