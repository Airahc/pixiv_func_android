/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:home_model.dart
 * 创建时间:2021/8/29 下午5:03
 * 作者:小草
 */

import 'package:pixiv_func_android/instance_setup.dart';
import 'package:pixiv_func_android/model/navigation_page.dart';
import 'package:pixiv_func_android/provider/base_view_model.dart';
import 'package:pixiv_func_android/ui/page/bookmarked/bookmarked_page.dart';
import 'package:pixiv_func_android/ui/page/download_task/download_task_page.dart';
import 'package:pixiv_func_android/ui/page/following_new_illust/following_new_illust_page.dart';
import 'package:pixiv_func_android/ui/page/following_user/following_user_page.dart';
import 'package:pixiv_func_android/ui/page/new_illust/new_illust_page.dart';
import 'package:pixiv_func_android/ui/page/ranking/ranking_selector_page.dart';
import 'package:pixiv_func_android/ui/page/recommended/recommended_page.dart';
import 'package:pixiv_func_android/ui/page/search/search_guide_page.dart';

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

  List<NavigationPage> get navigationPages => [
        NavigationPage(name: '推荐作品', page: RecommendedPage()),
        NavigationPage(name: '收藏的作品', page: BookmarkedPage()),
        NavigationPage(name: '最新作品(已关注的用户)', page: FollowingNewIllustPage()),
        NavigationPage(name: '最新作品(所有人)', page: NewIllustPage()),
        NavigationPage(name: '关注(的用户)', page: FollowingUserPage(int.parse(accountManager.current!.user.id))),
        NavigationPage(name: '排行榜', page: RankingSelectorPage()),
        NavigationPage(name: '搜索', page: SearchGuidePage()),
        NavigationPage(name: '下载任务', page: DownloadTaskPage()),
      ];

  void refresh() {
    notifyListeners();
  }
}
