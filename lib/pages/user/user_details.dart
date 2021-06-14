/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : user_details.dart
 */

import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/user_info/user_details.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/avatar_view_from_url.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserDetailsContent extends StatefulWidget {
  final int userId;

  UserDetailsContent(this.userId);

  @override
  _UserDetailsContentState createState() => _UserDetailsContentState();
}

class _UserDetailsContentState extends State<UserDetailsContent> {
  UserDetails? _userDetailsData;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future _loadData() async {
    final userInfo = await PixivRequest.instance.queryUserInfo(
      widget.userId,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: widget.userId,
          title: '查询用户信息失败',
          url: '',
          context: '在用户页面',
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
    }
  }

  Widget _userInfoItem(String name, String value) {
    return ListTile(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('取消'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Util.copyToClipboard('$value');
                    },
                    child: Text('确定'),
                  ),
                ],
                content: Text('复制到剪切板?'),
              );
            });
      },
      leading: Text(
        name,
      ),
      title: Center(
        child: Text(
          '$value',
        ),
      ),
    );
  }

  bool get _followed {
    if (_userDetailsData == null) {
      return false;
    } else {
      return _userDetailsData!.isFollowed;
    }
  }

  set _followed(bool value) {
    if (_userDetailsData != null) {
      _userDetailsData!.isFollowed = value;
    }
  }

  Widget _buildBody() {
    final list = <Widget>[];
    if (_userDetailsData != null) {
      final UserDetails userDetails = _userDetailsData!;

      if (userDetails.coverImage != null) {
        list.add(ImageViewFromUrl(
          userDetails.coverImage!.profileCoverImage.values.first,
        ));
      }
      list.add(SizedBox(height: 20));
      list.add(ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: AvatarViewFromUrl(userDetails.profileImg.main),
        trailing: IconButton(
          splashRadius: 20,
          icon: Icon(
            _followed ? Icons.favorite_sharp : Icons.favorite_outline_sharp,
            color: _followed ? Colors.pinkAccent : Colors.white54,
          ),
          onPressed: () async {
            if (_followed) {
              final success = await PixivRequest.instance.followUsersDelete(
                userDetails.userId,
                requestException: (e) {
                  LogUtil.instance.add(
                    type: LogType.NetworkException,
                    id: userDetails.userId,
                    title: '取消关注用户失败',
                    url: '',
                    context: '在用户页面',
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
                    id: userDetails.userId,
                    title: '取消关注用户失败',
                    url: '',
                    context: '',
                  );
                }
              }
            } else {
              final success = await PixivRequest.instance
                  .followUsersAdd(userDetails.userId, requestException: (e) {
                LogUtil.instance.add(
                  type: LogType.NetworkException,
                  id: userDetails.userId,
                  title: '关注用户失败',
                  url: '',
                  context: '在用户页面',
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
                    id: userDetails.userId,
                    title: '关注用户失败',
                    url: '',
                    context: '',
                  );
                }
              }
            }
          },
        ),
        title: Text(
          userDetails.userName,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text('${userDetails.follows}关注'),
      ));
      list.add(SizedBox(height: 20));
      list.add(Card(
        child: Container(
          child: SelectableText(
            '${userDetails.userComment}',
          ),
        ),
      ));

      list.add(SizedBox(height: 20));
      list.add(_userInfoItem('名称', '${userDetails.userName}'));
      list.add(Divider());

      list.add(_userInfoItem('用户ID', '${userDetails.userId}'));
      list.add(Divider());

      if (userDetails.userWebpage.isNotEmpty) {
        list.add(_userInfoItem('网站', '${userDetails.userWebpage}'));
        list.add(Divider());
      }

      if (userDetails.userSexTxt != null) {
        list.add(_userInfoItem('性别', '${userDetails.userSexTxt}'));
        list.add(Divider());
      }

      if (userDetails.userAge != null) {
        list.add(_userInfoItem('年龄', '${userDetails.userAge}'));
        list.add(Divider());
      }

      if (userDetails.userBirthTxt != null) {
        list.add(_userInfoItem('生日', '${userDetails.userBirthTxt}'));
        list.add(Divider());
      }

      if (userDetails.userCountry != null) {
        list.add(_userInfoItem('国家', '${userDetails.userCountry}'));
        list.add(Divider());
      }

      if (userDetails.location != null) {
        list.add(_userInfoItem('地区', '${userDetails.location}'));
        list.add(Divider());
      }

      if (userDetails.userJobTxt != null) {
        list.add(_userInfoItem('工作', '${userDetails.userJobTxt}'));
        list.add(Divider());
      }

      if (userDetails.social != null) {
        userDetails.social!.forEach((key, value) {
          list.add(_userInfoItem(key, value.values.first));
          list.add(Divider());
        });
      }
    }
    return ListView(
      children: list,
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _userDetailsData = null;

    });

    await _loadData();

    if (this.mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      scrollController: _scrollController,
      controller: _refreshController,
      header: MaterialClassicHeader(
        color: Colors.pinkAccent,
      ),
      onRefresh: _onRefresh,
      child: _buildBody(),
    );
  }
}
