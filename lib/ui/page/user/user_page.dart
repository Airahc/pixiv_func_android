/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_page.dart
 * 创建时间:2021/8/30 下午2:45
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/api/model/user_detail.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/page/following_user/following_user_page.dart';
import 'package:pixiv_func_android/ui/page/user/user_bookmarked/user_bookmarked.dart';
import 'package:pixiv_func_android/ui/page/user/user_details/user_details.dart';
import 'package:pixiv_func_android/ui/page/user/user_illust/user_illust.dart';
import 'package:pixiv_func_android/ui/widget/avatar_view_from_url.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/user_model.dart';
import 'package:pixiv_func_android/view_model/user_preview_model.dart';

class UserPage extends StatefulWidget {
  final int userId;
  final UserPreviewModel? parentModel;

  const UserPage(this.userId, {Key? key, this.parentModel}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 4, vsync: this);

  Widget _buildFlexibleSpaceBar(UserModel model) {
    final String? backgroundImageUrl = model.userDetail?.profile.backgroundImageUrl;
    final UserDetail detail = model.userDetail!;
    final UserInfo user = model.userDetail!.user;
    final children = <Widget>[];
    if (null != backgroundImageUrl) {
      children.add(
        Expanded(
          child: Container(
            child: ImageViewFromUrl(
              backgroundImageUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
    } else {
      children.add(
        Expanded(
          child: Container(
            child: Center(
              child: Text('没有背景图片'),
            ),
          ),
        ),
      );
    }

    children.add(
      ListTile(
        leading: AvatarViewFromUrl(
          user.profileImageUrls.medium,
          radius: 35,
        ),
        title: Text(user.name),
        subtitle: GestureDetector(
          onTap: () => PageUtils.to(context, FollowingUserPage(user.id)),
          child: Text('${detail.profile.totalFollowUsers}关注'),
        ),
        trailing: model.followRequestWaiting
            ? RefreshProgressIndicator()
            : model.isFollowed
                ? ElevatedButton(onPressed: () => model.onFollowStateChange(widget.parentModel), child: Text('已关注'))
                : OutlinedButton(onPressed: () => model.onFollowStateChange(widget.parentModel), child: Text('关注')),
      ),
    );
    children.add(
      SizedBox(
        height: 45,
      ),
    );
    return FlexibleSpaceBar(
      background: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: UserModel(widget.userId),
      builder: (BuildContext context, UserModel model, Widget? child) {
        if (ViewState.Busy == model.viewState) {
          return Scaffold(
            appBar: AppBar(title: Text('用户')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (ViewState.InitFailed == model.viewState) {
          return Scaffold(
            appBar: AppBar(title: Text('用户')),
            body: Center(
              child: ListTile(
                onTap: model.loadData,
                title: Center(
                  child: Text('加载失败,点击重新加载'),
                ),
              ),
            ),
          );
        } else if (ViewState.Empty == model.viewState) {
          return Scaffold(
            appBar: AppBar(title: Text('用户')),
            body: Center(
              child: ListTile(
                title: Center(
                  child: Text('用户ID:${widget.userId}不存在'),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverOverlapAbsorber(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverAppBar(
                    pinned: true,
                    expandedHeight: 320,
                    title: Text('用户'),
                    bottom: PreferredSize(
                      child: TabBar(
                        indicatorColor: Theme.of(context).colorScheme.secondary,
                        controller: _tabController,
                        onTap: (int index) => model.index = index,
                        tabs: [
                          Tab(
                            text: '资料',
                          ),
                          Tab(
                            text: '插画',
                          ),
                          Tab(
                            text: '漫画',
                          ),
                          Tab(
                            text: '收藏',
                          ),
                        ],
                      ),
                      preferredSize: Size.fromHeight(25),
                    ),
                    flexibleSpace: _buildFlexibleSpaceBar(model),
                  ),
                ),
              ];
            },
            body: Container(
              padding: EdgeInsets.only(top: kToolbarHeight + 50),
              child: TabBarView(
                controller: _tabController,
                children: [
                  null != model.userDetail ? UserDetails(model) : Container(),
                  UserIllust(widget.userId, WorkType.ILLUST),
                  UserIllust(widget.userId, WorkType.MANGA),
                  UserBookmarked(widget.userId),
                ],
              ),
            ),
          ),
        );
      },
      onModelReady: (UserModel model) => model.loadData(),
    );
  }
}
