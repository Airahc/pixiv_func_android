/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : bookmarking_page.dart
 */

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixiv_xiaocao_android/api/entity/bookmarks/bookmark.dart';
import 'package:pixiv_xiaocao_android/api/pixiv_request.dart';
import 'package:pixiv_xiaocao_android/component/image_view_from_url.dart';
import 'package:pixiv_xiaocao_android/config/config_util.dart';
import 'package:pixiv_xiaocao_android/log/log_entity.dart';
import 'package:pixiv_xiaocao_android/log/log_util.dart';
import 'package:pixiv_xiaocao_android/pages/illust/illust_page.dart';
import 'package:pixiv_xiaocao_android/util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookmarkingPage extends StatefulWidget {
  @override
  _BookmarkingPageState createState() => _BookmarkingPageState();
}

class _BookmarkingPageState extends State<BookmarkingPage> {
  List<Bookmark> _bookmarks = <Bookmark>[];

  final ScrollController _scrollController = ScrollController();

  final RefreshController _refreshController =
  RefreshController(initialRefresh: true);

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

  Future _loadData(
      {void Function()? onSuccess, void Function()? onFail}) async {
    var isSuccess = false;

    final bookmarks = await PixivRequest.instance.getBookmarks(
      ConfigUtil.instance.config.currentAccount.userId,
      _currentPage,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取已收藏书签失败',
          url: '',
          context: '在已收藏书签页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.currentAccount.userId,
          title: '获取已收藏书签反序列化异常',
          url: '',
          context: response,
          exception: e,
        );
      },
    );
    if (this.mounted) {
      if (bookmarks != null) {
        if (!bookmarks.error) {
          _hasNext = bookmarks.body!.lastPage > _currentPage++;
          print(_hasNext);
          _bookmarks.addAll(bookmarks.body!.bookmarks);
          isSuccess = true;
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: ConfigUtil.instance.config.currentAccount.userId,
            title: '获取已收藏书签失败',
            url: '',
            context: 'error:${bookmarks.message}',
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
        itemCount: _bookmarks.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        width: constraints.maxWidth,
                        height: constraints.maxWidth,
                        child: ImageViewFromUrl(
                          _bookmarks[index].urlS,
                          fit: BoxFit.cover,
                          imageBuilder: (Widget imageWidget) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Util.gotoPage(
                                      context,
                                      IllustPage(
                                        _bookmarks[index].id,
                                        onBookmarkAdd: (bookmarkId) {
                                          if (this.mounted) {
                                            setState(() {
                                              _bookmarks[index].bookmarkId =
                                                  bookmarkId;
                                            });
                                          }
                                        },
                                        onBookmarkDelete: () {
                                          if (this.mounted) {
                                            setState(() {
                                              _bookmarks[index].bookmarkId =
                                              null;
                                            });
                                          }
                                        },
                                      ),
                                    );
                                  },
                                  child: imageWidget,
                                ),
                                Positioned(
                                  left: 2,
                                  top: 2,
                                  child: _bookmarks[index].tags.contains('R-18')
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
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: Text(
                                          '${_bookmarks[index].pageCount}'),
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
                        '${_bookmarks[index].title}',
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                        '${_bookmarks[index].authorDetails.userName}',
                        style: TextStyle(fontSize: 10),
                      ),
                      // leading: AvatarViewFromUrl,
                      trailing: Util.buildBookmarkButton(
                        context,
                        illustId: _bookmarks[index].id,
                        bookmarkId: _bookmarks[index].bookmarkId,
                        updateCallback: (int? bookmarkId) {
                          if (this.mounted) {
                            setState(() {
                              _bookmarks[index].bookmarkId = bookmarkId;
                            });
                          }
                        },
                      ),
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
    if (_bookmarks.isNotEmpty) {
      component = _buildIllustsPreview();
    } else {
      component = Container();
    }

    return component;
  }

  Future<void> _onRefresh() async {
    setState(() {
      _bookmarks.clear();
      _currentPage = 1;
      _hasNext = true;

      if (_initialize) {
        _initialize = false;
      }
    });

    await _loadData();

    if (_bookmarks.isEmpty) {
      _refreshController.loadNoData();
    } else {
        setState(() {
          if (_hasNext) {
            if (!_initialize) {
              _initialize = true;
            }
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
        title: Text('已收藏的书签'),
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
