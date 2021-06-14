/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : user_page.dart
 */

// import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_bookmarks.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_details.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_works.dart';

class UserPage extends StatefulWidget {
  final int userId;

  UserPage(this.userId);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 4, vsync: this);

  int _currentPage = 0;

  GlobalKey<UserBookmarksContentState> _bookmarksGlobalKey = GlobalKey();

  List<GlobalKey<UserWorksContentState>> _worksGlobalKeys = [
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Text('详细'),
              Text('插画'),
              Text('漫画'),
              Text('收藏'),
            ],
            onTap: (index) {
              if (index == _currentPage) {
                if (index == 1) {
                  _worksGlobalKeys[0].currentState?.scrollToTop();
                } else if (index == 2) {
                  _worksGlobalKeys[1].currentState?.scrollToTop();
                } else if (index == 3) {
                  _bookmarksGlobalKey.currentState?.scrollToTop();
                }
              } else {
                _currentPage = index;
              }
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                UserDetailsContent(widget.userId),
                UserWorksContent(
                  type: UserWorkType.illust,
                  userId: widget.userId,
                  key: _worksGlobalKeys[0],
                ),
                UserWorksContent(
                  type: UserWorkType.manga,
                  userId: widget.userId,
                  key: _worksGlobalKeys[1],
                ),
                UserBookmarksContent(
                  userId: widget.userId,
                  key: _bookmarksGlobalKey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
