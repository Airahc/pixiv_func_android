/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:about_model.dart
 * 创建时间:2021/9/6 下午6:58
 * 作者:小草
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/model/release_info.dart';
import 'package:pixiv_func_android/provider/base_view_state_model.dart';

class AboutModel extends BaseViewStateModel {
  String? _appVersion;

  String? get appVersion => _appVersion;

  set appVersion(String? value) {
    _appVersion = value;
    notifyListeners();
  }

  ReleaseInfo? releaseInfo;

  void loadLatestReleaseInfo() {
    releaseInfo = null;
    setBusy();
    Dio().get<String>("https://api.github.com/repos/xiao-cao-x/pixiv-func-android/releases/latest").then((result) {
      final Map<String, dynamic> json = jsonDecode(result.data!);

      final firstAssets = (json['assets'] as List<dynamic>).first;

      releaseInfo = ReleaseInfo(
        htmlUrl: json['html_url'],
        tagName: json['tag_name'],
        updateAt: DateTime.parse(
          firstAssets['updated_at'] as String,
        ),
        browserDownloadUrl: firstAssets['browser_download_url'] as String,
        body: json['body'] as String,
      );
      setIdle();
    }).catchError((e, s) {
      Log.e('获取最新发行版信息失败');
      setInitFailed(e, s);
    });
  }

  Future<void> loadAppVersion() async {
    appVersion = await platformAPI.appVersion;
  }
}
