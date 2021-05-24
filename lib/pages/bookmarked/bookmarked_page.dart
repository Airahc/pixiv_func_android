/*
 * Copyright (C) 2021. by 小草, All rights reserved
 * 项目名称 : pixiv_xiaocao_android
 * 文件名称 : bookmarked_page.dart
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

class BookmarkedPage extends StatefulWidget {
  @override
  _BookmarkedPageState createState() => _BookmarkedPageState();
}

class _BookmarkedPageState extends State<BookmarkedPage> {
  List<Bookmark> _bookmarks = <Bookmark>[];

  ScrollController _scrollController = ScrollController();

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
          _bookmarks.clear();
          _currentPage = 1;
        }
        if (init) {
          _initialize = false;
        }
        _loading = true;
      });
    } else {
      return;
    }

    final bookmarks = await PixivRequest.instance.getBookmarks(
      ConfigUtil.instance.config.userId,
      _currentPage,
      requestException: (e) {
        LogUtil.instance.add(
          type: LogType.NetworkException,
          id: ConfigUtil.instance.config.userId,
          title: '获取已收藏书签失败',
          url: '',
          context: '在已收藏书签页面',
          exception: e,
        );
      },
      decodeException: (e, response) {
        LogUtil.instance.add(
          type: LogType.DeserializationException,
          id: ConfigUtil.instance.config.userId,
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
          setState(() {
            _hasNext = bookmarks.body!.lastPage != ++_currentPage;
            _bookmarks.addAll(bookmarks.body!.bookmarks);
          });
        } else {
          LogUtil.instance.add(
            type: LogType.Info,
            id: ConfigUtil.instance.config.userId,
            title: '获取已收藏书签失败',
            url: '',
            context: 'error:${bookmarks.message}',
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

  Widget _buildWorksGridView() {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      crossAxisCount: 2,
      itemCount: _bookmarks.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: [
                ImageViewFromUrl(
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
                                      _bookmarks[index].bookmarkId = bookmarkId;
                                    });
                                  }
                                },
                                onBookmarkDelete: () {
                                  if (this.mounted) {
                                    setState(() {
                                      _bookmarks[index].bookmarkId = null;
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
                              child: Text('${_bookmarks[index].pageCount}'),
                            ),
                          ),
                        ),
                      ],
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
    );
  }

  Widget _buildBody() {
    late Widget component;
    if (_bookmarks.isNotEmpty) {
      final List<Widget> list = [];
      list.add(_buildWorksGridView());

      if (_bookmarks.isNotEmpty) {
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
      }
      component = SingleChildScrollView(
        controller: _scrollController,
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

    return component;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('已收藏的书签'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildBody(),
        backgroundColor: Colors.white,
      ),
    );
  }
}
