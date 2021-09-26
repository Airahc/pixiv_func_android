/*
 * Copyright (C) 2021. by xiao-cao-x, All rights reserved
 * 项目名称:pixiv_func_android
 * 文件名称:user_page.dart
 * 创建时间:2021/8/30 下午2:45
 * 作者:小草
 */
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:pixiv_func_android/api/enums.dart';
import 'package:pixiv_func_android/api/model/user_detail.dart';
import 'package:pixiv_func_android/provider/provider_widget.dart';
import 'package:pixiv_func_android/provider/view_state.dart';
import 'package:pixiv_func_android/ui/page/following_user/following_user_page.dart';
import 'package:pixiv_func_android/ui/page/user/avatar_viewer.dart';
import 'package:pixiv_func_android/ui/page/user/user_bookmarked/user_bookmarked.dart';
import 'package:pixiv_func_android/ui/page/user/user_details/user_details.dart';
import 'package:pixiv_func_android/ui/page/user/user_illust/user_illust.dart';
import 'package:pixiv_func_android/ui/widget/avatar_view_from_url.dart';
import 'package:pixiv_func_android/ui/widget/image_view_from_url.dart';
import 'package:pixiv_func_android/util/page_utils.dart';
import 'package:pixiv_func_android/view_model/illust_content_model.dart';
import 'package:pixiv_func_android/view_model/user_model.dart';
import 'package:pixiv_func_android/view_model/user_preview_model.dart';

class UserPage extends StatefulWidget {
  final int id;
  final UserPreviewModel? parentModel;
  final IllustContentModel? illustContentModel;

  const UserPage(this.id, {Key? key, this.parentModel, this.illustContentModel}) : super(key: key);

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
        leading: GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => AvatarViewer(url: user.profileImageUrls.medium),
          ),
          child: Hero(
            tag: 'user:${user.id}',
            child: AvatarViewFromUrl(
              user.profileImageUrls.medium,
              radius: 35,
            ),
          ),
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
    return FlexibleSpaceBar(background: Column(children: children),collapseMode: CollapseMode.pin,);
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget(
      model: UserModel(widget.id),
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
                  child: Text('用户ID:${widget.id}不存在'),
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: ExtendedNestedScrollView(
            onlyOneScrollInBody: true,
            pinnedHeaderSliverHeightBuilder: () =>
            MediaQuery.of(context).padding.top + kToolbarHeight + 46.0,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  pinned: true,
                  // elevation: 0.0,
                  // forceElevated: innerBoxIsScrolled,
                  expandedHeight: 320,
                  title: Text('用户'),
                  flexibleSpace: _buildFlexibleSpaceBar(model),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: TabBarDelegate(
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
                  ),
                ),
              ];
            },
            body: Container(
              child: TabBarView(
                controller: _tabController,
                children: [

                  null != model.userDetail ? UserDetails(model) : Container(),
                  UserIllust(id: widget.id, type: WorkType.ILLUST, illustContentModel: widget.illustContentModel),
                  UserIllust(id: widget.id, type: WorkType.MANGA, illustContentModel: widget.illustContentModel),
                  UserBookmarked(widget.id),
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

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar child;

  TabBarDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(child: this.child, color: Theme.of(context).cardColor);
  }

  @override
  double get maxExtent => this.child.preferredSize.height;

  @override
  double get minExtent => this.child.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
