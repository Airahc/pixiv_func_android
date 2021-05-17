/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : config.dart
 */

import 'package:pixiv_xiaocao_android/util.dart';

class Config{
  static int userId = Util.getConfig<int>('UserId', defaultValue: 0);
  static String cookie =
  Util.getConfig<String>('Cookie', defaultValue: '');
  static String token = Util.getConfig<String>('Token', defaultValue: '');
  static String userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101 Firefox/88.0';
  static const referer = 'https://www.pixiv.net/';

  static String proxyIP =
  Util.getConfig<String>('ProxyIP', defaultValue: '127.0.0.1');
  static int proxyPort = Util.getConfig<int>('ProxyPort', defaultValue: 44001);

  static bool enableProxy =
  Util.getConfig<bool>('EnableProxy', defaultValue: false);

  static bool enableImageProxy =
  Util.getConfig<bool>('EnableImageProxy', defaultValue: true);

  static String savePath =
  Util.getConfig<String>('SavePath', defaultValue: '.\\PixivDownload');

  static bool createUserFolder =
  Util.getConfig<bool>('CreateUserFolder', defaultValue: true);

  static bool createIllustFolder =
  Util.getConfig<bool>('CreateUserFolder', defaultValue: true);
}
