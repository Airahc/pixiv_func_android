/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:instance_setup.dart
 * 创建时间:2021/8/23 下午12:55
 * 作者:小草
 */

import 'package:pixiv_func_android/api/oauth_api.dart';
import 'package:pixiv_func_android/api/pixiv_api.dart';
import 'package:pixiv_func_android/view_model/account_model.dart';
import 'package:pixiv_func_android/view_model/download_task_model.dart';
import 'package:pixiv_func_android/view_model/home_model.dart';
import 'package:pixiv_func_android/view_model/theme_model.dart';
import 'package:pixiv_func_android/browsing_history_manager.dart';
import 'package:pixiv_func_android/settings_manager.dart';
import 'package:pixiv_func_android/account_manager.dart';
import 'package:pixiv_func_android/platform/api/platform_api.dart';

AccountManager accountManager = AccountManager();
SettingsManager settingsManager = SettingsManager();
BrowsingHistoryManager browsingHistoryManager = BrowsingHistoryManager();
PixivAPI pixivAPI = PixivAPI();
OAuthAPI oAuthAPI = OAuthAPI();
PlatformAPI platformAPI = PlatformAPI();
ThemeModel themeModel = ThemeModel(settingsManager.isLightTheme);
AccountModel accountModel = AccountModel();
DownloadTaskModel downloadTaskModel = DownloadTaskModel();
HomeModel homeModel = HomeModel();

Future<void> init() async {
  await accountManager.load();
  await settingsManager.load();
  await browsingHistoryManager.init();
}
