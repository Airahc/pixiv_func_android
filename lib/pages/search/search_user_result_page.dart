/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : search_user_result_page.dart
 */
import 'package:flutter/material.dart';
import 'package:pixiv_xiaocao_android/api/entity/search_users/user.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/avatar_view_from_url.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/pages/user/user_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchUserResultPage extends StatefulWidget {
  final String nick;

  SearchUserResultPage(this.nick);

  @override
  _SearchUserResultPageState createState() => _SearchUserResultPageState();
}

class _SearchUserResultPageState extends State<SearchUserResultPage> {
  late String _searchNick = widget.nick;

  final List<User> _users = <User>[];

  final ScrollController _scrollController = ScrollController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  int _currentPage = 1;

  int _total = 0;

  bool _hasNext = true;
  bool _initialize = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      if (_scrollController.offset != 0) {
        _scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInQuad,
        );
      }
    }
  }

  Future _loadData(
      {void Function()? onSuccess, void Function()? onFail}) async {
    var isSuccess = false;

    final searchData = await PixivRequest.instance.searchUsers(
      _searchNick,
      page: _currentPage,
    );

    if (this.mounted) {
      if (searchData != null && searchData.body != null) {
        _hasNext = searchData.body!.lastPage > ++_currentPage;
        _total = searchData.body!.total;
        searchData.body!.users.forEach((user) {
          _users.add(user);
        });
        isSuccess = true;
      }
    }

    if (isSuccess) {
      onSuccess?.call();
    } else {
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
                            width: Util.getScreenSize(context).width / 3,
                            height: Util.getScreenSize(context).width / 3,
                            child: ImageViewFromUrl(
                              illust.urlS,
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
                      Util.gotoPage(context, UserPage(user.userId));
                    },
                    child: AvatarViewFromUrl(
                      user.profileImg.main,
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
      if (_hasNext) {
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    }

    if (this.mounted) {
      setState(() {
        if (!_initialize) {
          _initialize = true;
        }
        _refreshController.refreshCompleted();
      });
    }
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
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            heroTag: '滚动到顶部',
            backgroundColor: Colors.black.withAlpha(200),
            child: Icon(
              Icons.arrow_upward_outlined,
              color: Colors.white,
            ),
            onPressed: _scrollToTop,
          );
        },
      ),
      appBar: AppBar(
        leading: IconButton(
          tooltip: '返回',
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('${_users.length}/$_total条'),
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
