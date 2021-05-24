/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : followed_users_page.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/following/user_preview.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/avatar_view_from_url.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';

class FollowedUsersPage extends StatefulWidget {
  @override
  _FollowedUsersPageState createState() => _FollowedUsersPageState();
}

class _FollowedUsersPageState extends State<FollowedUsersPage> {
  List<UserPreview> _users = <UserPreview>[];

  static const int _pageQuantity = 30;

  int _currentPage = 1;

  bool _hasNext = true;
  bool _loading = false;
  bool _initialize = false;

  @override
  void initState() {
    _loadData(reload: false, init: true);
    super.initState();
  }

  Future _loadData({bool reload = true, bool init = false}) async {
    if (this.mounted) {
      setState(() {
        if (reload) {
          _users.clear();
          _currentPage = 1;
          _hasNext = true;
        }
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    final following = await PixivRequest.instance.getFollowing(
      ConfigUtil.instance.config.userId,
      (_currentPage - 1) * _pageQuantity,
      _pageQuantity,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.userId,
          title: '获取已关注用户失败',
          url: '',
          context: '在已关注用户页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.userId,
          title: '获取已关注用户反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );

    if (this.mounted) {
      if (following != null) {
        if (!following.error) {
          if (following.body != null) {
            setState(() {
              _hasNext = following.body!.total > ++_currentPage * _pageQuantity;
              _users.addAll(following.body!.users);
            });
          }
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: ConfigUtil.instance.config.userId,
            title: '获取已关注用户失败',
            url: '',
            context: 'error:${following.message}',
          );
        }
      }
    }

    if (this.mounted) {
      setState(() {
        if (init) {
          _initialize = true;
        }
        _loading = false;
      });
    }
  }

  Widget _buildUserCards() {
    return Column(
      children: _users.map((user) {
        return Container(
          child: Card(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Row(
                    children: user.illusts
                        .map((illust) => ImageViewFromUrl(
                              illust.url,
                              width: Util.windowSize.width / 3,
                              imageBuilder: (Widget imageWidget) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Util.gotoPage(
                                          context,
                                          IllustPage(illust.id),
                                        );
                                      },
                                      child: imageWidget,
                                    ),
                                    Positioned(
                                      left: 2,
                                      top: 2,
                                      child: illust.tags.contains('R-18')
                                          ? Card(
                                              color: Colors.pinkAccent,
                                              child: Text('R-18'),
                                            )
                                          : Container(),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 2,
                                      child: Card(
                                        color: Colors.white12,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          child: Text('${illust.pageCount}'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ))
                        .toList(),
                  ),
                  scrollDirection: Axis.horizontal,
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  leading: GestureDetector(
                    onTap: () {
                      Util.gotoPage(context, UserPage(user.userId));
                    },
                    child: AvatarViewFromUrl(
                      user.profileImageUrl,
                      radius: 35,
                    ),
                  ),
                  title: Text(user.userName),
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBody() {
    late Widget component;
    if (_users.isNotEmpty) {
      final List<Widget> list = [];
      list.add(_buildUserCards());
      if (_loading) {
        list.add(SizedBox(height: 20));
        list.add(Center(
          child: CircularProgressIndicator(),
        ));
        list.add(SizedBox(height: 20));
      } else {
        if (_hasNext) {
          list.add(Card(
            child: ListTile(
              title: Text('加载更多'),
              onTap: () {
                _loadData(reload: false);
              },
            ),
          ));
        } else {
          list.add(Card(child: ListTile(title: Text('没有更多数据啦'))));
        }
      }

      component = SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: list,
        ),
      );
    } else {
      if (_loading) {
        if (!_initialize) {
          component = Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          component = Container();
        }
      } else {
        component = ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Center(
                child: Text('没有任何数据'),
              ),
            );
          },
          physics: const AlwaysScrollableScrollPhysics(),
        );
      }
    }

    return Scrollbar(
      radius: Radius.circular(10),
      thickness: 10,
      child: component,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('已关注的用户'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
