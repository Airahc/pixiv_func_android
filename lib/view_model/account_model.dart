/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:account_model.dart
 * 创建时间:2021/8/23 下午12:51
 * 作者:小草
 */

import 'package:flutter/widgets.dart';
import 'package:pixiv_func_android/api/entity/local_user.dart';
import 'package:pixiv_func_android/api/model/user_account.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/log/log.dart';
import 'package:pixiv_func_android/platform/webview/platform_web_view.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';
import 'package:pixiv_func_android/util/page_utils.dart';

class AccountModel extends BaseViewModel {
  List<LocalUser> get accounts => accountManager.accounts.map((e) => e.user).toList();

  void add(UserAccount account) {
    accountManager.add(account);
    if (accountManager.accounts.length == 1) {
      accountManager.select(0);
    }
    notifyListeners();
  }

  void remove(String id, {required void Function() back}) {
    final removeIndex = accountManager.accounts.indexWhere((account) => account.user.id == id);

    accountManager.remove(accountManager.accounts[removeIndex]);

    if (removeIndex == accountManager.index) {
      if (accountManager.accounts.isNotEmpty) {
        accountManager.select(0);
      } else {
        back();
        accountManager.select(-1);
      }
    }

    notifyListeners();
  }

  void select(String id) {
    accountManager.select(accountManager.accounts.indexWhere((account) => account.user.id == id));
    notifyListeners();
  }

  void login(
    BuildContext context, {
    required void Function(UserAccount account) onLoginSuccess,
    bool create = false,
    bool useLocalReverseProxy = true,
  }) {
    final s = oAuthAPI.randomString(128);

    final url = 'https://app-api.pixiv.net/web/v1/' +
        (create ? 'provisional-accounts/create' : 'login') +
        '?code_challenge=${oAuthAPI.generateCodeChallenge(s)}&code_challenge_method=S256&client=pixiv-android';

    PageUtils.to(
      context,
      PlatformWebView(
        useLocalReverseProxy: useLocalReverseProxy,
        url: url,
        onMessageHandler: (BuildContext context, dynamic message) async {
          final map = message as Map;
          switch (map['type']) {
            case 'code':
              final code = map['content'] as String;

              Log.i('code:$code');
              oAuthAPI.initAccountAuthToken(code, s).then((result) {
                onLoginSuccess(result);
                PageUtils.back(context);
              }).catchError((e) {
                Log.e('登录失败', e);
              });

              break;
          }
        },
      ),
    );
  }
}
