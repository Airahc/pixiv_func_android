/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : user_page.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/user_info/user_details.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/avatar_view_from_url.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_bookmarks.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_details_dialog.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_works.dart';

class UserPage extends StatefulWidget {
  final int userId;

  UserPage(this.userId);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 3, vsync: this);

  UserDetails? _userDetailsData;

  bool _loading = false;

  int _currentIndex = 0;

  GlobalKey<UserBookmarksContentState> _bookmarksGlobalKey = GlobalKey();

  List<GlobalKey<UserWorksContentState>> _worksGlobalKeys = [
    GlobalKey(),
    GlobalKey(),
  ];

  @override
  void initState() {
    _loadData(reload: false);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future _loadData({bool reload = true}) async {
    if (this.mounted) {
      setState(() {
        if (reload) {
          _userDetailsData = null;
        }
        _loading = true;
      });
    } else {
      return;
    }

    final userInfo = await PixivRequest.instance.queryUserInfo(
      widget.userId,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: widget.userId,
          title: '查询用户信息失败',
          url: '',
          context: '在用户界面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: widget.userId,
          title: '查询用户信息反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );
    if (this.mounted) {
      if (userInfo != null && userInfo.body != null) {

        _userDetailsData = userInfo.body!.userDetails;
      }
    } else {
      return;
    }

    setState(() {
      _loading = false;
    });
  }

  bool get _followed {
    if (_userDetailsData != null) {
      return _userDetailsData!.isFollowed;
    } else {
      return false;
    }
  }

  set _followed(bool value) {
    if (_userDetailsData != null) {
      _userDetailsData!.isFollowed = value;
    }
  }

  Widget _buildUserPreview() {
    return Container(
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: GestureDetector(
          child: AvatarViewFromUrl(_userDetailsData!.profileImg.main),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return UserDetailsDialog(_userDetailsData!);
              },
            );
          },
        ),
        trailing: _userDetailsData != null
            ? IconButton(
                splashRadius: 20,
                icon: Icon(
                  _followed
                      ? Icons.favorite_sharp
                      : Icons.favorite_outline_sharp,
                  color: _followed ? Colors.pinkAccent : Colors.white54,
                ),
                onPressed: () async {
                  if (_followed) {
                    final success =
                        await PixivRequest.instance.followUserDelete(
                      widget.userId,
                      requestException: (e) {
                        LogUtil.instance.add(
                          type: LogType.NetworkException,
                          id: widget.userId,
                          title: '取消关注用户失败',
                          url: '',
                          context: '在用户界面',
                          exception: e,
                        );
                      },
                    );
                    if (this.mounted) {
                      if (success) {
                        setState(() {
                          _followed = false;
                        });
                      } else {
                        LogUtil.instance.add(
                          type: LogType.Info,
                          id: widget.userId,
                          title: '取消关注用户失败',
                          url: '',
                          context: '只是单纯的没成功',
                        );
                      }
                    }
                  } else {
                    final success = await PixivRequest.instance
                        .followUserAdd(widget.userId, requestException: (e) {
                      LogUtil.instance.add(
                        type: LogType.NetworkException,
                        id: widget.userId,
                        title: '关注用户失败',
                        url: '',
                        context: '在用户界面',
                        exception: e,
                      );
                    });
                    if (this.mounted) {
                      if (success) {
                        setState(() {
                          _followed = true;
                        });
                      } else {
                        LogUtil.instance.add(
                          type: LogType.Info,
                          id: widget.userId,
                          title: '关注用户失败',
                          url: '',
                          context: '只是单纯的没成功',
                        );
                      }
                    }
                  }
                },
              )
            : null,
        title: Text(
          _userDetailsData!.userName,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${_userDetailsData!.follows}关注'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _userDetailsData != null
            ? _buildUserPreview()
            : !_loading
                ? Text('加载用户数据失败')
                : null,
        actions: [
          IconButton(
            splashRadius: 20,
            icon: Icon(Icons.refresh_outlined),
            onPressed: _loadData,
          )
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: [
              Text('插画'),
              Text('漫画'),
              Text('收藏'),
            ],
            onTap: (int index) {
              if (_currentIndex != index && _tabController.index == index) {
                _currentIndex = index;
              } else {
                if (index != 2) {
                  _worksGlobalKeys[index].currentState?.scrollToTop();
                } else {
                  _bookmarksGlobalKey.currentState?.scrollToTop();
                }
              }
            },
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
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
          )
        ],
      ),
    );
  }
}
