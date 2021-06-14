/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : user_bookmarks.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/user_bookmarks/work.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UserBookmarksContent extends StatefulWidget {
  final int userId;

  UserBookmarksContent({required this.userId, Key? key}) : super(key: key);

  @override
  UserBookmarksContentState createState() => UserBookmarksContentState();
}

class UserBookmarksContentState extends State<UserBookmarksContent>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final List<Work> _works = <Work>[];

  final ScrollController _scrollController = ScrollController();

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
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void scrollToTop() {
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

    final userBookmarks = await PixivRequest.instance.queryUserBookmarks(
      widget.userId,
      (_currentPage - 1) * _pageQuantity,
      _pageQuantity,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: widget.userId,
          title: '查询用户已收藏作品失败',
          url: '',
          context: '在用户页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: widget.userId,
          title: '查询用户已收藏作品反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );

    if (this.mounted) {
      if (userBookmarks != null) {
        if (!userBookmarks.error) {
          if (userBookmarks.body != null) {
            _hasNext =
                userBookmarks.body!.total > _currentPage++ * _pageQuantity;
            _works.addAll(userBookmarks.body!.works);
            isSuccess = true;
          }
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: widget.userId,
            title: '查询用户已收藏作品失败',
            url: '',
            context: 'error:${userBookmarks.message}',
          );
        }
      }
    }

    if (isSuccess) {
      onSuccess?.call();
    } else {
      onFail?.call();
    }
  }

  Widget _buildIllustsPreview() {
    return Container(
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        itemCount: _works.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        itemBuilder: (BuildContext context, int index) {
          return _works[index].isMasked
              ? Card(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        child: ImageViewFromUrl(_works[index].url),
                      );
                    },
                  ),
                )
              : Card(
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Container(
                              width: constraints.maxWidth,
                              height: constraints.maxWidth,
                              child: ImageViewFromUrl(
                                _works[index].url,
                                fit: BoxFit.cover,
                                imageBuilder: (Widget imageWidget) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Util.gotoPage(
                                            context,
                                            IllustPage(_works[index].id),
                                          );
                                        },
                                        child: imageWidget,
                                      ),
                                      Positioned(
                                        left: 2,
                                        top: 2,
                                        child:
                                            _works[index].tags.contains('R-18')
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
                                            child: Text(
                                              '${_works[index].pageCount}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              '${_works[index].title}',
                              style: TextStyle(fontSize: 14),
                            ),
                            subtitle: Text('${_works[index].userName}',
                                style: TextStyle(fontSize: 10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildBody() {
    late Widget component;
    if (_works.isNotEmpty) {
      component = _buildIllustsPreview();
    } else {
      component = Container();
    }
    return component;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _works.clear();
      _currentPage = 1;
      _hasNext = true;

      if (_initialize) {
        _initialize = false;
      }
    });

    await _loadData();
    if (_works.isEmpty) {
      _refreshController.loadNoData();
    } else {
        setState(() {
        if (!_initialize) {
          _initialize = true;
        }
        if (_hasNext) {
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
    super.build(context);
    return SmartRefresher(
      scrollController: _scrollController,
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: _initialize,
      header: MaterialClassicHeader(
        color: Colors.pinkAccent,
      ),
      footer: _initialize
          ? CustomFooter(
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
            )
          : null,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: _buildBody(),
    );
  }
}
