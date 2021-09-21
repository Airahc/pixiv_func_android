/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:release_info.dart
 * 创建时间:2021/9/6 下午8:21
 * 作者:小草
 */

class ReleaseInfo {
  String htmlUrl;
  String tagName;

  //更新时间
  DateTime updateAt;
  String browserDownloadUrl;
  String body;

  ReleaseInfo({
    required this.htmlUrl,
    required this.tagName,
    required this.updateAt,
    required this.browserDownloadUrl,
    required this.body,
  });
}
