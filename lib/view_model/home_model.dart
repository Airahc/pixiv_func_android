/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:home_model.dart
 * 创建时间:2021/8/29 下午5:03
 * 作者:小草
 */

import 'package:flutter/material.dart';
import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/navigation_page.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';
import 'package:pixiv_func_android/ui/page/about/about_page.dart';
import 'package:pixiv_func_android/ui/page/account/account_page.dart';
import 'package:pixiv_func_android/ui/page/bookmarked/bookmarked_page.dart';
import 'package:pixiv_func_android/ui/page/browsing_history/browsing_history_page.dart';
import 'package:pixiv_func_android/ui/page/download_task/download_task_page.dart';
import 'package:pixiv_func_android/ui/page/following_user/following_user_page.dart';
import 'package:pixiv_func_android/ui/page/new_works/new_works_page.dart';
import 'package:pixiv_func_android/ui/page/ranking/ranking_selector_page.dart';
import 'package:pixiv_func_android/ui/page/recommended/recommended_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_guide_page.dart';
import 'package:pixiv_func_android/ui/page/settings/settings_page.dart';

class HomeModel extends BaseViewModel {
  int _currentPage = 0;
  bool _agreementAccepted = false;

  bool get agreementAccepted => _agreementAccepted;

  set agreementAccepted(bool value) {
    _agreementAccepted = value;
    notifyListeners();
  }

  int get currentPage => _currentPage;

  set currentPage(int value) {
    if (value != _currentPage) {
      _currentPage = value;
      notifyListeners();
    }
  }

  final List<Widget> navigationPages = [
    const RecommendedPage(),
    const RankingSelectorPage(),
    const DownloadTaskPage(),
  ];

  List<NavigationPage> get pages => [
        NavigationPage(name: '收藏', widget: const BookmarkedPage()),
        NavigationPage(name: '最新', widget: const NewWorksPage()),
        NavigationPage(name: '关注', widget: FollowingUserPage(int.parse(accountManager.current!.user.id))),
        NavigationPage(name: '搜索', widget: const SearchGuidePage()),
        NavigationPage(name: '设置', widget: const SettingsPage()),
        NavigationPage(name: '账号', widget: const AccountPage()),
        NavigationPage(name: '浏览历史记录(本地)', widget: const BrowsingHistoryPage()),
        NavigationPage(name: '关于', widget: const AboutPage()),
      ];

  void refresh() {
    notifyListeners();
  }
}
