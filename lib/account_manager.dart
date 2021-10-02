/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:account_manager.dart
 * 创建时间:2021/8/23 上午10:55
 * 作者:小草
 */

import 'dart:convert';

import 'package:pixiv_func_android/api/model/user_account.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountManager {
  static const _dataKeyName = "accounts";
  static const _dataIndexKeyName = "account_index";

  final List<UserAccount> _accounts = [];

  late final SharedPreferences sharedPreferences;

  Future<void> load() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final tempAccounts = sharedPreferences.getStringList(_dataKeyName);
    if (null == tempAccounts) {
      return;
    }

    _accounts.addAll(
      tempAccounts.map(
        (jsonString) {
          final json = jsonDecode(jsonString);
          return UserAccount.fromJson(json);
        },
      ),
    );
  }

  ///保存账号
  void save() {
    sharedPreferences.setStringList(_dataKeyName, _accounts.map((account) => jsonEncode(account.toJson())).toList());
  }

  void select(int index) async {
    sharedPreferences.setInt(_dataIndexKeyName, index);
  }

  ///没有选定为-1
  int get index {
    return sharedPreferences.getInt(_dataIndexKeyName) ?? (_accounts.isNotEmpty ? 0 : -1);
  }

  UserAccount? get current {
    final currentIndex = index;
    if (-1 == currentIndex) {
      return null;
    }
    return _accounts[currentIndex];
  }

  ///添加账号
  void add(UserAccount account) {
    //如果已经存在就更新
    if (_accounts.any((element) => element.user.id == account.user.id)) {
      update(account);
    } else {
      _accounts.add(account);
    }
    save();
  }

  ///更新账号
  void update(UserAccount account) {
    for (int i = 0; i < _accounts.length; i++) {
      if (account.user.id == _accounts[i].user.id) {
        _accounts[i] = account;
        save();
        break;
      }
    }
  }

  ///移除账号
  void remove(UserAccount account) {
    _accounts.remove(account);
    save();
  }

  List<UserAccount> get accounts => _accounts;

  bool get isEmpty => accounts.isEmpty;

  bool get isNotEmpty => accounts.isNotEmpty;
}
