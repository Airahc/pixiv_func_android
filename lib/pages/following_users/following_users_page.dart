/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : following_users_page.dart
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
import 'package:pixiv_xiaocao_android/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FollowingUsersPage extends StatefulWidget {
  @override
  _FollowingUsersPageState createState() => _FollowingUsersPageState();
}

class _FollowingUsersPageState extends State<FollowingUsersPage> {
  final List<UserPreview> _users = <UserPreview>[];

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  static const int _pageQuantity = 30;

  int _currentPage = 1;

  bool _hasNext = true;

  bool _initialize = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future _loadData(
      {void Function()? onSuccess, void Function()? onFail}) async {
    var isSuccess=false;
    final following = await PixivRequest.instance.getFollowing(
      ConfigUtil.instance.config.currentAccount.userId,
      (_currentPage - 1) * _pageQuantity,
      _pageQuantity,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取已关注用户失败',
          url: '',
          context: '在已关注用户页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.currentAccount.userId,
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
              _hasNext = following.body!.total > _currentPage++ * _pageQuantity;
              _users.addAll(following.body!.users);
            });
            isSuccess=true;
          }
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: ConfigUtil.instance.config.currentAccount.userId,
            title: '获取已关注用户失败',
            url: '',
            context: 'error:${following.message}',
          );
        }
      }
    }
    if(isSuccess){
      onSuccess?.call();
    }else{
      onFail?.call();
    }
  }

  Widget _buildUserCards() {
    return ListView(
      children: _users.map((user) {
        return Container(
          child: Card(
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Row(
                    children: user.illusts
                        .map(
                          (illust) => Container(
                            width: Utils.getScreenSize(context).width / 3,
                            height: Utils.getScreenSize(context).width / 3,
                            child: ImageViewFromUrl(
                              illust.url,
                              width: Utils.windowSize.width / 3,
                              imageBuilder: (Widget imageWidget) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Utils.gotoPage(
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
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  scrollDirection: Axis.horizontal,
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  leading: GestureDetector(
                    onTap: () {
                      Utils.gotoPage(context, UserPage(user.userId));
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
      component = _buildUserCards();
    } else {
      component = Container();
    }

    return component;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _users.clear();
      _currentPage = 1;
      _hasNext = true;

      if (_initialize) {
        _initialize = false;
      }
    });

    await _loadData();
    if (_users.isEmpty) {
      _refreshController.loadNoData();
    } else {
        setState(() {
                      if (!_initialize) {
              _initialize = true;
            }if (_hasNext) {

            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        });
    }


    _refreshController.refreshCompleted();
  }

  Future<void> _onLoading() async {
    await _loadData(onSuccess: () {
      if (this.mounted) {
        setState(() {
          if (_hasNext) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        });
      }
    }, onFail: () {
      _refreshController.loadFailed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('已关注的用户'),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: _initialize,
        header: MaterialClassicHeader(
          color: Colors.pinkAccent,
        ),
        footer: CustomFooter(
                builder: (BuildContext context, LoadStatus? mode) {
                  Widget body;
                  switch (mode) {
                    case LoadStatus.idle:
                      body = Text("上拉,加载更多");
                      break;
                    case LoadStatus.canLoading:
                      body = Text("松手,加载更多");
                      break;
                    case LoadStatus.loading:
                      body = CircularProgressIndicator();
                      break;
                    case LoadStatus.noMore:
                      body = Text("没有更多数据啦");
                      break;
                    case LoadStatus.failed:
                      body = Text('加载失败');
                      break;
                    default:
                      body = Container();
                      break;
                  }

                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: _buildBody(),
      ),
    );
  }
}
